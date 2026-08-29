-- Ensure admin account has correct bcrypt hash for 'admin123'
INSERT INTO admins (email, password_hash)
VALUES ('admin@restoreexpress.com', '$2a$10$MrwodC4t4RKqQus5ouholO8S9wNkQApe7c0TsUxCngQTzPgEJJggS')
ON CONFLICT (email) DO UPDATE SET password_hash = EXCLUDED.password_hash;
