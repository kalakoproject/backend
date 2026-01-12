import dotenv from 'dotenv';
dotenv.config();

export const PORT = process.env.PORT || 4000;
export const DATABASE_URL = process.env.DATABASE_URL;
export const JWT_SECRET = process.env.JWT_SECRET || 'changeme';
export const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '7d';

// Domain helpers so local (kalako.local) and prod can share the same code path
const fallbackDomain = 'kalako.local';
const rawRootDomain = process.env.ROOT_DOMAIN || process.env.BASE_DOMAIN || fallbackDomain;

// Root domain without any api. prefix (needed for cookies and host checks)
export const ROOT_DOMAIN = rawRootDomain.replace(/^api\./, '');

// Base domain for tenant extraction (also stripped from api. prefix)
export const BASE_DOMAIN = (process.env.BASE_DOMAIN || rawRootDomain || fallbackDomain).replace(/^api\./, '');

// Cookie domain shared across subdomains
export const COOKIE_DOMAIN = process.env.COOKIE_DOMAIN || `.${ROOT_DOMAIN}`;

export const EMAIL_USER = process.env.EMAIL_USER;
export const EMAIL_PASS = process.env.EMAIL_PASS;
