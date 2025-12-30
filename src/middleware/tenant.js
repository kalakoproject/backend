import { BASE_DOMAIN } from '../config.js';
import { query } from '../db.js';

export async function tenantMiddleware(req, res, next) {
  const host = req.headers.host;
  if (!host) return res.status(400).json({ message: 'Host header missing' });

  const withoutPort = host.split(':')[0];        // api.portorey.my.id or tokomaju.portorey.my.id
  const parts = withoutPort.split('.');

  let subdomain = null;
  
  // 1. Try to extract subdomain from hostname (for tenant-specific domains)
  if (withoutPort.endsWith(BASE_DOMAIN) && parts.length > 2) {
    const prefix = parts[0];
    // If hostname is like "api.portorey.my.id", skip it and check X-Tenant header
    if (prefix !== 'api') {
      subdomain = prefix;  // tokomaju from tokomaju.portorey.my.id
    }
  }

  // 2. If no subdomain from hostname, try X-Tenant header (for global API domain)
  if (!subdomain && req.headers['x-tenant']) {
    subdomain = req.headers['x-tenant'].toLowerCase().trim();
  }

  req.subdomain = subdomain;

  if (!subdomain) {
    // No subdomain identified; domain utama / admin
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
