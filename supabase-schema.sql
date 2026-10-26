-- ==============================================================================
-- SCALES by Zencrypt - Complete PostgreSQL & Supabase Database Setup Script
-- https://zencrypt.in
-- ==============================================================================

-- 1. Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. STORES TABLE
CREATE TABLE IF NOT EXISTS stores (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL DEFAULT 'My Store',
  logo_url TEXT DEFAULT '',
  whatsapp_number TEXT DEFAULT '',
  currency TEXT NOT NULL DEFAULT '₹',
  settings JSONB DEFAULT '{"themeColor": "#2563eb"}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. CATEGORIES TABLE
CREATE TABLE IF NOT EXISTS categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  icon_url TEXT DEFAULT '',
  sort_order INTEGER DEFAULT 0,
  is_visible BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. PRODUCTS TABLE
CREATE TABLE IF NOT EXISTS products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  price NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
  description TEXT DEFAULT '',
  availability TEXT DEFAULT 'In Stock',
  stock_status TEXT DEFAULT 'in_stock',
  is_visible BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  specifications JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. PRODUCT IMAGES TABLE
CREATE TABLE IF NOT EXISTS product_images (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. PERFORMANCE INDEXES
CREATE INDEX IF NOT EXISTS idx_categories_store ON categories(store_id);
CREATE INDEX IF NOT EXISTS idx_categories_visible ON categories(is_visible);
CREATE INDEX IF NOT EXISTS idx_products_store ON products(store_id);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_visible ON products(is_visible);
CREATE INDEX IF NOT EXISTS idx_product_images_product ON product_images(product_id);

-- 7. INITIAL DEFAULT STORE ROW (Ensures immediate readiness)
INSERT INTO stores (name, currency, whatsapp_number, settings)
SELECT 
  'My Store',
  '₹',
  '+1234567890',
  '{"themeColor": "#2563eb"}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM stores);

-- ==============================================================================
-- 8. ROW LEVEL SECURITY (RLS) POLICIES
-- Ensures public visitors can ONLY read visible products.
-- Write/Update/Delete requires authenticated Supabase session.
-- ==============================================================================

ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_images ENABLE ROW LEVEL SECURITY;

-- Drop any existing policies
DROP POLICY IF EXISTS "Public can view stores" ON stores;
DROP POLICY IF EXISTS "Public can view visible categories" ON categories;
DROP POLICY IF EXISTS "Public can view visible products" ON products;
DROP POLICY IF EXISTS "Public can view product images" ON product_images;
DROP POLICY IF EXISTS "Authenticated admin has full access on stores" ON stores;
DROP POLICY IF EXISTS "Authenticated admin has full access on categories" ON categories;
DROP POLICY IF EXISTS "Authenticated admin has full access on products" ON products;
DROP POLICY IF EXISTS "Authenticated admin has full access on product_images" ON product_images;

-- Public READ-ONLY Access
CREATE POLICY "Public can view stores"
ON stores FOR SELECT
TO anon, authenticated
USING (true);

CREATE POLICY "Public can view visible categories"
ON categories FOR SELECT
TO anon, authenticated
USING (is_visible = true);

CREATE POLICY "Public can view visible products"
ON products FOR SELECT
TO anon, authenticated
USING (is_visible = true);

CREATE POLICY "Public can view product images"
ON product_images FOR SELECT
TO anon, authenticated
USING (true);

-- Authenticated Admin FULL-CONTROL Access
CREATE POLICY "Authenticated admin has full access on stores"
ON stores FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "Authenticated admin has full access on categories"
ON categories FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "Authenticated admin has full access on products"
ON products FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "Authenticated admin has full access on product_images"
ON product_images FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

-- ==============================================================================
-- 9. STORAGE BUCKET CONFIGURATION (catalogue-images)
-- Run this in SQL or create bucket 'catalogue-images' in Supabase Dashboard
-- ==============================================================================

INSERT INTO storage.buckets (id, name, public)
VALUES ('catalogue-images', 'catalogue-images', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- Drop existing storage policies if any
DROP POLICY IF EXISTS "Public can view catalogue images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload catalogue images" ON storage.objects;

-- Allow public read access to uploaded images
CREATE POLICY "Public can view catalogue images"
ON storage.objects FOR SELECT
TO anon, authenticated
USING (bucket_id = 'catalogue-images');

-- Allow authenticated admin to upload/delete images
CREATE POLICY "Authenticated users can upload catalogue images"
ON storage.objects FOR ALL
TO authenticated
USING (bucket_id = 'catalogue-images')
WITH CHECK (bucket_id = 'catalogue-images');
