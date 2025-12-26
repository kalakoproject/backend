import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { query, withTransaction } from '../db.js';
import { sendEmail } from '../utils/sendEmail.js';
import { JWT_SECRET, JWT_EXPIRES_IN } from '../config.js';
import { authMiddleware, addToBlacklist } from '../middleware/auth.js';

const router = express.Router();

// helper slugify untuk subdomain
function slugify(str) {
  return String(str)
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

async function generateUniqueSubdomain(baseName) {
  let slug = slugify(baseName);
  if (!slug) slug = 'client';

  let candidate = slug;
  let counter = 1;

  while (true) {
    const res = await query('SELECT 1 FROM clients WHERE subdomain = $1', [candidate]);
    if (res.rowCount === 0) return candidate;
    counter++;
    candidate = `${slug}-${counter}`;
  }
}

// ====== 1. KIRIM OTP EMAIL ======
router.post('/send-otp-email', async (req, res) => {
  const { email } = req.body;

  if (!email) return res.status(400).json({ message: 'Email wajib diisi' });

  const normalizedEmail = String(email).trim().toLowerCase();

  // Tolak jika email sudah terdaftar sebagai client
  try {
    const exists = await query('SELECT 1 FROM clients WHERE LOWER(email) = $1', [normalizedEmail]);
    if (exists.rowCount > 0) {
      return res.status(409).json({ message: 'Email sudah digunakan' });
    }
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: 'Gagal memeriksa email' });
  }

  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

  try {
    await query(
      'INSERT INTO email_otp_codes (email, otp, expires_at) VALUES ($1,$2,$3)',
      [normalizedEmail, otp, expiresAt]
    );

    await sendEmail(normalizedEmail, 'Kode OTP Pendaftaran Kalako', `Kode OTP Anda: ${otp}`);

    res.json({ message: 'OTP telah dikirim ke email.' });
  } catch (err) {
    // Jika terjadi duplikasi id akibat sequence tidak sinkron, selaraskan lalu coba sekali lagi
    if (err && err.code === '23505' && err.constraint === 'email_otp_codes_pkey') {
      try {
        await query(
          "SELECT setval('public.email_otp_codes_id_seq', COALESCE((SELECT MAX(id) FROM public.email_otp_codes), 0), true)"
        );
        await query(
          'INSERT INTO email_otp_codes (email, otp, expires_at) VALUES ($1,$2,$3)',
          [normalizedEmail, otp, expiresAt]
        );
        await sendEmail(normalizedEmail, 'Kode OTP Pendaftaran Kalako', `Kode OTP Anda: ${otp}`);
        return res.json({ message: 'OTP telah dikirim ke email.' });
      } catch (retryErr) {
        console.error('Retry after sequence fix failed:', retryErr);
      }
    }
    console.error(err);
    res.status(500).json({ message: 'Gagal mengirim OTP' });
  }
});

// ====== 2. SIGNUP CLIENT DENGAN OTP EMAIL ======
router.post('/client/signup-with-otp', async (req, res) => {
  let {
    store_name,
    owner_name,
    owner_id_number,
    address,
    phone,
    email,
    username,
    password,
    otp,
    city,
    district,
    sub_district,
    province,
    store_photo_url
  } = req.body;

  if (!store_name || !owner_name || !phone || !username || !password || !email || !otp) {
    return res.status(400).json({ message: 'Data wajib belum lengkap' });
  }

  email = String(email).trim().toLowerCase();
  otp = String(otp).trim();


  try {
    // Cek email belum dipakai client lain
    const emailUsed = await query('SELECT 1 FROM clients WHERE LOWER(email) = $1', [email]);
    if (emailUsed.rowCount > 0) {
      return res.status(409).json({ message: 'Email sudah digunakan' });
    }

    // cek OTP
    const otpRes = await query(
      `SELECT * FROM email_otp_codes
       WHERE email = $1 AND otp = $2 AND expires_at > NOW()
       ORDER BY id DESC LIMIT 1`,
      [email, otp]
    );

    if (otpRes.rowCount === 0) {
      return res.status(400).json({ message: 'OTP salah atau kadaluarsa' });
    }

    // hapus semua OTP untuk email ini
    await query('DELETE FROM email_otp_codes WHERE email = $1', [email]);

    // Username boleh sama di tenant berbeda. Tidak perlu cek global di sini.

    const subdomain = await generateUniqueSubdomain(store_name);
    const passwordHash = await bcrypt.hash(password, 10);

    const result = await withTransaction(async (db) => {
      const clientRes = await db.query(
        `INSERT INTO clients
    (name, owner_name, owner_id_number, address, phone, email, subdomain, status, trial_ends_at,
     city, district, sub_district, province, store_photo_url)
   VALUES ($1,$2,$3,$4,$5,$6,$7,$8, NOW() + INTERVAL '14 days',
           $9,$10,$11,$12,$13)
   RETURNING *`,
        [
          store_name,
          owner_name,
          owner_id_number || null,
          address || null,
          phone,
          email,
          subdomain,
          'trial',
          city || null,
          district || null,
          sub_district || null,
          province || null,
          store_photo_url || null
        ]
      );

      const client = clientRes.rows[0];

      const userRes = await db.query(
        `INSERT INTO users (client_id, name, username, password_hash, role)
         VALUES ($1,$2,$3,$4,$5)
         RETURNING id`,
        [client.id, owner_name, username, passwordHash, 'client_admin']
      );

      return { client, userId: userRes.rows[0].id, clientId: client.id };
    });



    const token = jwt.sign({ userId: result.userId, clientId: result.clientId, role: 'client_admin' }, JWT_SECRET, {
      expiresIn: JWT_EXPIRES_IN
    });

    res.status(201).json({
      message: 'Pendaftaran client berhasil',
      client: {
        id: result.client.id,
        name: result.client.name,
        subdomain: result.client.subdomain
      },
      token
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Gagal mendaftar client' });
  }
});

// ====== 2b. CEK KETERSEDIAAN EMAIL ======
router.get('/check-email', async (req, res) => {
  const email = String(req.query.email || '').trim().toLowerCase();
  if (!email) return res.status(400).json({ message: 'Email wajib diisi' });
  try {
    const exists = await query('SELECT 1 FROM clients WHERE LOWER(email) = $1', [email]);
    const available = exists.rowCount === 0;
    res.json({ available });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Gagal memeriksa email' });
  }
});

// ====== 3. LOGIN ======
router.post('/login', async (req, res) => {
  const { username, password } = req.body;
  const { client } = req;

  if (!username || !password) {
    return res.status(400).json({ message: 'Username dan password wajib diisi' });
  }

  try {
    let user;

    if (client) {
      // Login di subdomain tenant: hanya user milik tenant ini yang boleh
      const userRes = await query('SELECT * FROM users WHERE username = $1 AND client_id = $2', [username, client.id]);
      if (userRes.rowCount === 0) {
        return res.status(403).json({ message: 'Akses ditolak untuk subdomain ini' });
      }
      user = userRes.rows[0];
    } else {
      // Domain utama: hanya super_admin yang boleh login di sini
      const userRes = await query("SELECT * FROM users WHERE username = $1 AND role = 'super_admin'", [username]);
      if (userRes.rowCount === 0) {
        return res.status(403).json({ message: 'Akun ini harus login via subdomain toko' });
      }
      user = userRes.rows[0];
    }

    const ok = await bcrypt.compare(password, user.password_hash);
    if (!ok) {
      return res.status(400).json({ message: 'Username atau password salah' });
    }

    console.log("User data:", { userId: user.id, clientId: user.client_id, role: user.role });
    const token = jwt.sign({ userId: user.id, clientId: user.client_id, role: user.role }, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });
    res.cookie("token", token, {
      httpOnly: false,
      sameSite: "lax",
      domain: ".kalako.local",
      path: "/",
      maxAge: 7 * 24 * 60 * 60 * 1000,
    });
    res.json({ message: 'Login berhasil', token, role: user.role });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Gagal login' });
  }
});

router.post("/logout", (req, res) => {
  // Ambil token dari header atau cookie jika ada
  let token = null;
  const authHeader = req.headers.authorization;
  if (authHeader && authHeader.startsWith("Bearer ")) {
    token = authHeader.split(" ")[1];
  }
  
  // Jika ada token valid, tambahkan ke blacklist
  if (token) {
    try {
      jwt.verify(token, process.env.JWT_SECRET);
      addToBlacklist(token);
      console.log("✅ Token added to blacklist:", token.substring(0, 20) + "...");
    } catch (err) {
      console.log("⚠️ Token invalid or expired:", err.message);
      // Token sudah invalid, tidak masalah
    }
  } else {
    console.log("⚠️ No token provided in logout request");
  }

  res.clearCookie("token", {
    domain: ".kalako.local",
    path: "/",
  });
  return res.json({ message: "Logged out successfully" });
});


export default router;
