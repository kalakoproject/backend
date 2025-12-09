import express from "express";
import { pool } from "../db.js";
import { authMiddleware } from "../middleware/auth.js";

const router = express.Router();

/**
 * POST /api/transactions
 * body: { items: [{product_id, quantity}], paid_amount }
 */
router.post("/", authMiddleware, async (req, res) => {
  const clientId = req.client.id;
  const user = req.user;
  const cashierId = user.id;
  const { items, paid_amount } = req.body;

  if (!items || !Array.isArray(items) || items.length === 0) {
    return res.status(400).json({ message: "Item transaksi kosong" });
  }

  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    let total = 0;
    const detailRows = [];

    for (const it of items) {
      const { product_id, quantity } = it;
      const qty = Number(quantity);
      if (!product_id || !qty || qty <= 0) {
        throw new Error("Item tidak valid");
      }

      const prodRes = await client.query(
        `SELECT id, name, selling_price, stock, unit
         FROM products
         WHERE id=$1 AND client_id=$2
         FOR UPDATE`,
        [product_id, clientId]
      );

      if (prodRes.rowCount === 0) {
        throw new Error("Produk tidak ditemukan");
      }

      const prod = prodRes.rows[0];
      const newStock = Number(prod.stock) - qty;
      if (newStock < 0) {
        throw new Error(`Stok ${prod.name} tidak mencukupi`);
      }

      const unitPrice = Number(prod.selling_price);
      const subtotal = unitPrice * qty;
      total += subtotal;

      await client.query(
        `UPDATE products
         SET stock=$1, last_out_at=NOW()
         WHERE id=$2`,
        [newStock, product_id]
      );

      detailRows.push({
        product_id,
        quantity: qty,
        unit_price: unitPrice,
        subtotal,
        name: prod.name,
        unit: prod.unit,
      });
    }

    const paid = Number(paid_amount);
    if (isNaN(paid) || paid < total) {
      throw new Error("Uang bayar kurang dari total");
    }
    const change = paid - total;

    const trxRes = await client.query(
      `INSERT INTO sales_transactions
        (client_id, cashier_id, total_amount, paid_amount, change_amount)
       VALUES ($1,$2,$3,$4,$5)
       RETURNING *`,
      [clientId, cashierId, total, paid, change]
    );
    const trx = trxRes.rows[0];

    for (const d of detailRows) {
      await client.query(
        `INSERT INTO sales_transaction_items
          (transaction_id, product_id, quantity, unit_price, subtotal)
         VALUES ($1,$2,$3,$4,$5)`,
        [trx.id, d.product_id, d.quantity, d.unit_price, d.subtotal]
      );
    }

    await client.query("COMMIT");

    res.status(201).json({
      transaction: trx,
      items: detailRows,
    });
  } catch (err) {
    await client.query("ROLLBACK");
    console.error(err);
    res.status(400).json({ message: err.message || "Gagal simpan transaksi" });
  } finally {
    client.release();
  }
});

/**
 * GET /api/transactions
 * Get transaction history
 */
router.get("/", authMiddleware, async (req, res) => {
  const clientId = req.client.id;
  const { limit = 50, offset = 0, search = "" } = req.query;

  try {
    let query = `
      SELECT 
        st.id, 
        st.total_amount, 
        st.paid_amount, 
        st.change_amount,
        st.created_at,
        u.username as cashier_name,
        COUNT(sti.id) as item_count
      FROM sales_transactions st
      LEFT JOIN users u ON st.cashier_id = u.id
      LEFT JOIN sales_transaction_items sti ON st.id = sti.transaction_id
      WHERE st.client_id = $1
    `;
    const params = [clientId];

    if (search) {
      query += ` AND (u.username ILIKE $${params.length + 1} OR st.id::TEXT ILIKE $${params.length + 1})`;
      params.push(`%${search}%`);
    }

    query += ` GROUP BY st.id, st.total_amount, st.paid_amount, st.change_amount, st.created_at, u.username`;
    query += ` ORDER BY st.created_at DESC`;
    query += ` LIMIT $${params.length + 1} OFFSET $${params.length + 2}`;
    params.push(limit, offset);

    const result = await pool.query(query, params);
    
    // Get total count
    let countQuery = `
      SELECT COUNT(*) as total
      FROM sales_transactions st
      LEFT JOIN users u ON st.cashier_id = u.id
      WHERE st.client_id = $1
    `;
    const countParams = [clientId];
    
    if (search) {
      countQuery += ` AND (u.username ILIKE $${countParams.length + 1} OR st.id::TEXT ILIKE $${countParams.length + 1})`;
      countParams.push(`%${search}%`);
    }

    const countResult = await pool.query(countQuery, countParams);
    const total = parseInt(countResult.rows[0].total);

    res.json({
      transactions: result.rows,
      total,
      limit,
      offset,
    });
  } catch (err) {
    console.error(err);
    res.status(400).json({ message: err.message || "Gagal fetch transaksi" });
  }
});

/**
 * GET /api/transactions/:id/items
 * Get items detail for a transaction
 */
router.get("/:id/items", authMiddleware, async (req, res) => {
  const clientId = req.client.id;
  const { id } = req.params;

  try {
    const result = await pool.query(
      `
      SELECT 
        sti.id,
        sti.quantity,
        sti.unit_price,
        sti.subtotal,
        p.name as product_name,
        p.unit
      FROM sales_transaction_items sti
      LEFT JOIN products p ON sti.product_id = p.id
      WHERE sti.transaction_id = $1
      AND EXISTS (
        SELECT 1 FROM sales_transactions 
        WHERE id = $1 AND client_id = $2
      )
      `,
      [id, clientId]
    );

    res.json({ items: result.rows });
  } catch (err) {
    console.error(err);
    res.status(400).json({ message: err.message || "Gagal fetch detail transaksi" });
  }
});

export default router;
