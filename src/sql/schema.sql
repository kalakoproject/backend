CREATE TABLE IF NOT EXISTS clients (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  owner_name VARCHAR(150) NOT NULL,
  owner_id_number VARCHAR(50),
  address TEXT,
  phone VARCHAR(50),
  email VARCHAR(150) UNIQUE,
  subdomain VARCHAR(100) UNIQUE NOT NULL,
  city VARCHAR(100),
  district VARCHAR(100),
  sub_district VARCHAR(100),
  province VARCHAR(100),
  store_photo_url TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS users (
  id BIGSERIAL PRIMARY KEY,
  client_id BIGINT REFERENCES clients(id) ON DELETE CASCADE,
  username VARCHAR(50) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  email VARCHAR(150),
  role VARCHAR(50) NOT NULL, -- super_admin, client_admin, cashier, etc
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS email_otp_codes (
  id BIGSERIAL PRIMARY KEY,
  email VARCHAR(150) NOT NULL,
  otp VARCHAR(10) NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS product_categories (
  id BIGSERIAL PRIMARY KEY,
  client_id BIGINT REFERENCES clients(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
  id BIGSERIAL PRIMARY KEY,
  client_id BIGINT REFERENCES clients(id) ON DELETE CASCADE,
  name VARCHAR(150) NOT NULL,
  selling_price NUMERIC(15,2) NOT NULL DEFAULT 0,
  stock NUMERIC(15,3) NOT NULL DEFAULT 0,
  unit VARCHAR(20) NOT NULL DEFAULT 'PCS', -- PCS, KG, L, etc
  category_id BIGINT REFERENCES product_categories(id),
  expiry_date DATE,
  last_out_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales_transactions (
  id BIGSERIAL PRIMARY KEY,
  client_id BIGINT REFERENCES clients(id) ON DELETE CASCADE,
  cashier_id BIGINT REFERENCES users(id),
  total_amount NUMERIC(15,2) NOT NULL,
  paid_amount NUMERIC(15,2) NOT NULL,
  change_amount NUMERIC(15,2) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS sales_transaction_items (
  id BIGSERIAL PRIMARY KEY,
  transaction_id BIGINT REFERENCES sales_transactions(id) ON DELETE CASCADE,
  product_id BIGINT REFERENCES products(id),
  quantity NUMERIC(15,3) NOT NULL,
  unit_price NUMERIC(15,2) NOT NULL,
  subtotal NUMERIC(15,2) NOT NULL
);
-- opsional
CREATE TABLE IF NOT EXISTS customers (
  id BIGSERIAL PRIMARY KEY,
  client_id BIGINT REFERENCES clients(id) ON DELETE CASCADE,
  name VARCHAR(150),
  phone VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW()
);
