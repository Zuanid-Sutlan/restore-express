INSERT INTO products (brand, model_name, slug, description, condition, storage_variant, color, price_pence, stock_quantity, is_active)
VALUES
('Apple', 'iPhone 15 Pro', 'iphone-15-pro-256-blue', 'Excellent condition refurbished iPhone.', 'REFURBISHED_A', '256GB', 'Blue Titanium', 89900, 5, true),
('Samsung', 'Galaxy S24 Ultra', 'samsung-s24-ultra-512-black', 'Brand new flagship Samsung device.', 'NEW', '512GB', 'Titanium Black', 114900, 3, true),
('Google', 'Pixel 8', 'google-pixel-8-128-rose', 'Used Pixel 8 with minor scratches.', 'USED', '128GB', 'Rose', 45000, 2, true)
ON CONFLICT (slug) DO NOTHING;
