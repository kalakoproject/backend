import express from "express";
import ExcelJS from "exceljs";
import PDFDocument from "pdfkit";
import { authMiddleware } from "../middleware/auth.js";
import { pool } from "../db.js";

const router = express.Router();

function getDateFilter(range) {
  if (range === "monthly") {
    return "DATE_TRUNC('month', t.created_at) = DATE_TRUNC('month', CURRENT_DATE)";
  }
  if (range === "weekly") {
    return "DATE_TRUNC('week', t.created_at) = DATE_TRUNC('week', CURRENT_DATE)";
  }
  if (range === "yearly") {
    return "DATE_TRUNC('year', t.created_at) = DATE_TRUNC('year', CURRENT_DATE)";
  }
  return "DATE(t.created_at) = CURRENT_DATE"; // daily
}

router.get("/products", authMiddleware, async (req, res) => {
  const clientId = req.client.id;
  const range = req.query.range || "daily";
  const limit = parseInt(req.query.limit) || 25;
  const offset = parseInt(req.query.offset) || 0;

  const dateFilter = getDateFilter(range);

  try {
    const dataRes = await pool.query(
      `SELECT p.id, p.name,
              COALESCE(SUM(i.quantity),0) AS jumlah,
              COALESCE(SUM(i.subtotal),0) AS total_pendapatan
       FROM sales_transaction_items i
       JOIN sales_transactions t ON t.id = i.transaction_id
       JOIN products p ON p.id = i.product_id
       WHERE t.client_id = $1 AND ${dateFilter}
       GROUP BY p.id, p.name
       ORDER BY SUM(i.subtotal) DESC
       LIMIT $2 OFFSET $3`,
      [clientId, limit, offset]
    );

    const countRes = await pool.query(
      `SELECT COUNT(*) AS total FROM (
         SELECT p.id FROM sales_transaction_items i
         JOIN sales_transactions t ON t.id = i.transaction_id
         JOIN products p ON p.id = i.product_id
         WHERE t.client_id = $1 AND ${dateFilter}
         GROUP BY p.id
       ) s`,
      [clientId]
    );

    res.json({
      rows: dataRes.rows.map((r) => ({
        id: r.id,
        name: r.name,
        jumlah: Number(r.jumlah),
        total_pendapatan: Number(r.total_pendapatan),
      })),
      total: Number(countRes.rows[0].total || 0),
      limit,
      offset,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Error fetching product report" });
  }
});

router.get("/products/export", authMiddleware, async (req, res) => {
  const clientId = req.client.id;
  const range = req.query.range || "daily";
  const format = (req.query.format || "pdf").toLowerCase();

  const dateFilter = getDateFilter(range);

  try {
    const dataRes = await pool.query(
      `SELECT p.id, p.name,
              COALESCE(SUM(i.quantity),0) AS jumlah,
              COALESCE(SUM(i.subtotal),0) AS total_pendapatan
       FROM sales_transaction_items i
       JOIN sales_transactions t ON t.id = i.transaction_id
       JOIN products p ON p.id = i.product_id
       WHERE t.client_id = $1 AND ${dateFilter}
       GROUP BY p.id, p.name
       ORDER BY SUM(i.subtotal) DESC`,
      [clientId]
    );

    const rows = dataRes.rows.map((r, idx) => ({
      no: idx + 1,
      name: r.name,
      jumlah: Number(r.jumlah),
      total_pendapatan: Number(r.total_pendapatan),
    }));

    if (format === "excel") {
      const workbook = new ExcelJS.Workbook();
      const sheet = workbook.addWorksheet("Laporan Penjualan");
      sheet.columns = [
        { header: "No", key: "no", width: 6 },
        { header: "Nama Produk", key: "name", width: 40 },
        { header: "Jumlah", key: "jumlah", width: 12 },
        { header: "Total Pendapatan", key: "total_pendapatan", width: 18 },
      ];
      rows.forEach((r) => sheet.addRow(r));

      // add summary row with total pendapatan for the selected period
      const totalRevenue = rows.reduce((s, r) => s + (r.total_pendapatan || 0), 0);
      sheet.addRow([]);
      const summaryRow = sheet.addRow({ name: "Total Pendapatan", total_pendapatan: totalRevenue });
      summaryRow.eachCell((cell) => {
        cell.font = { bold: true };
      });

      res.setHeader(
        "Content-Type",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      );
      res.setHeader(
        "Content-Disposition",
        `attachment; filename="laporan_penjualan_${range}.xlsx"`
      );
      await workbook.xlsx.write(res);
      res.end();
      return;
    }

    res.setHeader("Content-Type", "application/pdf");
    res.setHeader(
      "Content-Disposition",
      `attachment; filename="laporan_penjualan_${range}.pdf"`
    );

    const doc = new PDFDocument({ size: "A4", margin: 30 });
    doc.pipe(res);

    doc.fontSize(16).text("Laporan Penjualan", { align: "center" });
    doc.moveDown(0.5);
    doc.fontSize(10).text(`Periode: ${range}`, { align: "center" });
    doc.moveDown(1);

    const tableTop = doc.y + 10;
    const itemX = {
      no: 40,
      name: 80,
      jumlah: 360,
      total: 440,
    };

    doc.fontSize(10).text("No", itemX.no, tableTop);
    doc.text("Nama Produk", itemX.name, tableTop);
    doc.text("Jumlah", itemX.jumlah, tableTop);
    doc.text("Total Pendapatan", itemX.total, tableTop);
    doc.moveDown(0.5);

    let y = tableTop + 20;
    rows.forEach((r) => {
      if (y > 750) {
        doc.addPage();
        y = 40;
      }
      doc.fontSize(9).text(r.no.toString(), itemX.no, y);
      doc.text(r.name, itemX.name, y, { width: 260 });
      doc.text(r.jumlah.toString(), itemX.jumlah, y);
      doc.text(new Intl.NumberFormat("id-ID", { style: "currency", currency: "IDR" }).format(r.total_pendapatan), itemX.total, y);
      y += 18;
    });

    // write total revenue summary for the exported period
    const totalRevenue = rows.reduce((s, r) => s + (r.total_pendapatan || 0), 0);
    if (y > 720) {
      doc.addPage();
      y = 40;
    }
    doc.moveDown(0.5);
    doc.fontSize(10).font('Helvetica-Bold').text('Total Pendapatan', itemX.name, y);
    doc.text(new Intl.NumberFormat("id-ID", { style: "currency", currency: "IDR" }).format(totalRevenue), itemX.total, y);

    doc.end();
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Error export report" });
  }
});

/**
 * GET /api/reports/monthly-sales
 * returns aggregated sales data per month for chart (all 12 months)
 */
router.get("/monthly-sales", authMiddleware, async (req, res) => {
  const clientId = req.client.id;

  try {
    const dataRes = await pool.query(
      `SELECT m.bulan_num, m.nama_bulan,
              COALESCE(SUM(t.total_amount),0) AS total
       FROM (
         VALUES 
         (1, 'Januari'), (2, 'Februari'), (3, 'Maret'), (4, 'April'),
         (5, 'Mei'), (6, 'Juni'), (7, 'Juli'), (8, 'Agustus'),
         (9, 'September'), (10, 'Oktober'), (11, 'November'), (12, 'Desember')
       ) AS m(bulan_num, nama_bulan)
       LEFT JOIN sales_transactions t ON t.client_id = $1 
         AND EXTRACT(MONTH FROM t.created_at) = m.bulan_num
         AND DATE_TRUNC('year', t.created_at) = DATE_TRUNC('year', CURRENT_DATE)
       GROUP BY m.bulan_num, m.nama_bulan
       ORDER BY m.bulan_num`,
      [clientId]
    );

    res.json({
      chart: dataRes.rows.map((r) => ({
        bulan: r.nama_bulan,
        total: Number(r.total),
      })),
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Error fetching monthly sales" });
  }
});

export default router;
