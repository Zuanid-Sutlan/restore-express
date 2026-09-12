INSERT INTO products (brand, model_name, slug, description, condition, storage_variant, color, price_pence, stock_quantity, is_active)
VALUES
('Apple', 'iPhone 15 Pro 256GB Titanium', 'iphone-15-pro-256-titanium', 'Brand new factory sealed flagship iPhone 15 Pro with 12-month Apple warranty. Advance online payment via Stripe.', 'NEW', '256GB', 'Natural Titanium', 99900, 10, true),
('Apple', 'iPhone 14 Pro Max 128GB Deep Purple (Grade A)', 'iphone-14-pro-max-128-purple-refurbished', 'Refurbished Grade A pristine condition iPhone 14 Pro Max. Tested & 100% operational with 90%+ battery health. 12-month warranty included.', 'REFURBISHED_A', '128GB', 'Deep Purple', 74900, 8, true),
('Samsung', 'Galaxy S24 Ultra 512GB Titanium Black', 'samsung-s24-ultra-512-black', 'Brand new sealed Samsung Galaxy S24 Ultra with Galaxy AI and S-Pen. Full manufacturer warranty.', 'NEW', '512GB', 'Titanium Black', 114900, 5, true),
('Google', 'Pixel 8 Pro 128GB Bay Blue (Grade B)', 'google-pixel-8-pro-128-blue-used', 'Pre-owned Grade B Google Pixel 8 Pro with minor cosmetic scuffs on rear casing. Screen is pristine and fully functional.', 'USED', '128GB', 'Bay Blue', 49900, 4, true),
('Anker', '65W Fast GaN Dual USB-C Charger', 'anker-65w-fast-gan-charger', 'Brand new Anker PowerPort 65W GaN fast charger. Compatible with iPhone, Samsung Galaxy, Pixel, and iPads.', 'NEW', 'Accessory', 'Black', 2999, 50, true),
('Spigen', 'Ultra Hybrid Clear Case for iPhone 15 Pro', 'spigen-ultra-hybrid-iphone-15-pro-case', 'Brand new Spigen shockproof crystal clear case with yellowing resistance.', 'NEW', 'Accessory', 'Clear', 1499, 100, true),
('Apple', 'AirPods Pro 2nd Gen with MagSafe USB-C (Refurbished)', 'apple-airpods-pro-2-refurbished', 'Refurbished Grade A AirPods Pro 2nd Gen with Active Noise Cancellation and MagSafe USB-C charging case.', 'REFURBISHED_A', 'Accessory', 'White', 17900, 12, true),
('Belkin', 'BoostCharge Pro 3-in-1 Wireless MagSafe Charger', 'belkin-boostcharge-3in1-magsafe', 'Brand new Belkin 15W fast wireless charging stand for iPhone, Apple Watch, and AirPods.', 'NEW', 'Accessory', 'White', 9999, 15, true)
ON CONFLICT (slug) DO NOTHING;
