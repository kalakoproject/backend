import { BASE_DOMAIN } from '../config.js';
import { query } from '../db.js';

export async function tenantMiddleware(req, res, next) {
  const host = req.headers.host;
  if (!host) return res.status(400).json({ message: 'Host header missing' });

  const withoutPort = host.split(':')[0];        // tokomaju.kalako.local
  const parts = withoutPort.split('.');

  let subdomain = null;
  if (withoutPort.endsWith(BASE_DOMAIN) && parts.length > 2) {
    subdomain = parts[0];                        // tokomaju
  }

  req.subdomain = subdomain;

  if (!subdomain) {
    // domain utama / admin
    return next();
  }

  try {
    const result = await query('SELECT * FROM clients WHERE subdomain = $1', [subdomain]);
    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Client not found for this subdomain' });
    }
    req.client = result.rows[0];
    next();
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Error resolving tenant' });
  }
}
