import jwt from 'jsonwebtoken';
import { JWT_SECRET } from '../config.js';
import { query } from '../db.js';

// Blacklist token yang sudah di-logout (simple in-memory, bisa pakai Redis untuk production)
const tokenBlacklist = new Set();

export function addToBlacklist(token) {
  tokenBlacklist.add(token);
}

export function isBlacklisted(token) {
  return tokenBlacklist.has(token);
}

export function authMiddleware(req, res, next) {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const token = authHeader.split(" ")[1];

    // Cek apakah token sudah di-logout
    if (isBlacklisted(token)) {
      console.log("❌ Token is blacklisted:", token.substring(0, 20) + "...");
      return res.status(401).json({ message: "Token sudah di-logout, silakan login kembali" });
    }

    console.log("✅ Token is valid (not blacklisted):", token.substring(0, 20) + "...");

    const payload = jwt.verify(token, process.env.JWT_SECRET);

    // payload harus berisi clientId, sesuaikan dengan proses login
    // misalnya waktu sign token: { userId: user.id, clientId: user.client_id, role: user.role }
    req.user = {
      id: payload.userId,
      role: payload.role,
    };
    req.client = {
      id: payload.clientId,
    };
    req.token = token; // Simpan token di req untuk logout

    return next(); // <-- wajib
  } catch (err) {
    console.error("authMiddleware error:", err);
    return res.status(401).json({ message: "Invalid token" });
  }
}
