import express from "express";
import { authMiddleware } from "../middleware/auth.js";
import { query } from "../db.js";

const router = express.Router();

/**
 * GET /api/dashboard/client-info
 * Get client store info including photo URL
 */
router.get("/client-info", authMiddleware, async (req, res) => {
  const clientId = req.client.id;
  try {
    const clientRes = await query(
      `SELECT 
         id, 
         name, 
         address, 
         city, 
         district, 
         sub_district, 
         province, 
         phone, 
         email, 
         store_photo_url 
       FROM clients 
       WHERE id = $1`,
      [clientId]
    );

    if (clientRes.rowCount === 0) {
      return res.status(404).json({ message: "Client not found" });
    }

    res.json(clientRes.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Error fetching client info" });
  }
});

/**
 * GET /api/dashboard/summary?range=daily|monthly|yearly
 */
router.get("/summary", authMiddleware, async (req, res) => {
  const clientId = req.client.id;
  const range = req.query.range || "daily";

  let dateFilter = "DATE(t.created_at) = CURRENT_DATE";
  if (range === "monthly") {
    dateFilter = "DATE_TRUNC('month', t.created_at) = DATE_TRUNC('month', CURRENT_DATE)";
  } else if (range === "yearly") {
    dateFilter = "DATE_TRUNC('year', t.created_at) = DATE_TRUNC('year', CURRENT_DATE)";
  }

  try {
    const totalStockRes = await query(
      "SELECT COALESCE(SUM(stock),0) AS total FROM products WHERE client_id=$1",
      [clientId]
    );
    const totalSoldRes = await query(
      `SELECT COALESCE(SUM(quantity),0) AS total
       FROM sales_transaction_items i
       JOIN sales_transactions t ON t.id = i.transaction_id
       WHERE t.client_id=$1 AND ${dateFilter}`,
      [clientId]
    );
    const totalCustomersRes = await query(
      `SELECT COUNT(*) AS total FROM customers WHERE client_id=$1`,
      [clientId]
    ).catch(() => ({ rows: [{ total: 0 }] })); // jika tabel belum ada

    const incomeRes = await query(
      `SELECT COALESCE(SUM(total_amount),0) AS total, COUNT(*) AS orders
       FROM sales_transactions t
       WHERE t.client_id=$1 AND ${dateFilter}`,
      [clientId]
    );

    const chartRes = await query(
      `SELECT TO_CHAR(t.created_at, 'DD Mon') AS label,
              SUM(total_amount) AS value
       FROM sales_transactions t
       WHERE t.client_id=$1 AND ${dateFilter.replace(
         "DATE(t.created_at)",
         "DATE(t.created_at)"
       )}
       GROUP BY label
       ORDER BY MIN(t.created_at)`,
      [clientId]
    );

    res.json({
      totalStock: Number(totalStockRes.rows[0].total || 0),
      totalSold: Number(totalSoldRes.rows[0].total || 0),
      totalCustomers: Number(totalCustomersRes.rows[0].total || 0),
      incomeTotal: Number(incomeRes.rows[0].total || 0),
      incomeOrders: Number(incomeRes.rows[0].orders || 0),
      incomeChart: chartRes.rows.map((r) => ({
        label: r.label,
        value: Number(r.value),
      })),
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Error dashboard" });
  }
});

export default router;
