CREATE TABLE site_settings (
    key VARCHAR(100) PRIMARY KEY,
    value TEXT NOT NULL
);

INSERT INTO site_settings (key, value) VALUES
('whatsapp_number', '18005557378'),
('facebook_url', 'https://facebook.com/restoreexpress'),
('instagram_url', 'https://instagram.com/restoreexpress'),
('youtube_url', 'https://youtube.com/restoreexpress'),
('twitter_url', 'https://x.com/restoreexpress'),
('phone_number', '+1 (800) 555-RESTORE'),
('support_email', 'support@restoreexpress.com')
ON CONFLICT (key) DO NOTHING;
