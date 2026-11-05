-- Raw landing tables (the star schema is built with dbt in v4)
CREATE TABLE IF NOT EXISTS raw_transactions (
    transaction_id  TEXT PRIMARY KEY,
    customer_id     TEXT NOT NULL,
    merchant_id     TEXT NOT NULL,
    channel         TEXT NOT NULL,
    amount          NUMERIC(12,2),
    fee             NUMERIC(12,2),
    status          TEXT NOT NULL,
    created_at      TIMESTAMP NOT NULL,
    loaded_at       TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS raw_customers (
    customer_id  TEXT PRIMARY KEY,
    region       TEXT,
    signup_date  DATE
);

CREATE TABLE IF NOT EXISTS raw_merchants (
    merchant_id    TEXT PRIMARY KEY,
    merchant_name  TEXT,
    category       TEXT
);

CREATE INDEX IF NOT EXISTS idx_raw_tx_created_at ON raw_transactions (created_at);
