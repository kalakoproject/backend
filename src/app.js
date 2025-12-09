import express from 'express';
import cors from 'cors';
import { tenantMiddleware } from './middleware/tenant.js';
import authRoutes from './routes/auth.js';
import uploadRoutes from "./routes/upload.js";
import retailRoutes from "./routes/retail.js";
import transactionRoutes from "./routes/transaction.js";
import dashboardRoutes from "./routes/dashboard.js";
import cookieParser from "cookie-parser";

const app = express();

app.use(cookieParser());
app.use(cors());
app.use(express.json());
app.use(tenantMiddleware);

app.use("/api/auth", authRoutes);
app.use("/api/retail", retailRoutes);
app.use("/api/transactions", transactionRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/upload", uploadRoutes);         // ⬅️ dan ini

app.get('/', (req, res) => {
  res.json({
    message: 'Kalako backend with email OTP',
    tenant: req.client?.subdomain || null
  });
});

app.use("/uploads", express.static("uploads"));  // serve file
app.use("/api/upload", uploadRoutes);

export default app;
