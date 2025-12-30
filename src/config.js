import dotenv from 'dotenv';
dotenv.config();

export const PORT = process.env.PORT || 4000;
export const DATABASE_URL = process.env.DATABASE_URL;
export const JWT_SECRET = process.env.JWT_SECRET || 'changeme';
export const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '7d';
export const BASE_DOMAIN = process.env.BASE_DOMAIN || 'api.portorey.my.id';

export const EMAIL_USER = process.env.EMAIL_USER;
export const EMAIL_PASS = process.env.EMAIL_PASS;
