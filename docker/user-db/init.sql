CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    institution VARCHAR(100),
    last_read_id INT DEFAULT 0,
    last_active TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS subscriptions (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    plan_name VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    expires_at TIMESTAMP DEFAULT (CURRENT_TIMESTAMP + INTERVAL '1 year')
);

-- Seed demo student
INSERT INTO users (id, username, full_name, institution, last_read_id)
VALUES (1, 'salma_mit', 'Salma Al-Harbi', 'Massachusetts Institute of Technology (MIT)', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO subscriptions (user_id, plan_name, is_active)
VALUES (1, 'Cengage Unlimited - Premium Student Access', TRUE)
ON CONFLICT DO NOTHING;

SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));