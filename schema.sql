-- =============================================================================
-- Retail sales schema (SQLite)
-- Four tables in a classic star-like layout, plus one view that every analysis
-- query builds on.
-- =============================================================================

DROP VIEW  IF EXISTS v_sales;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id   INTEGER PRIMARY KEY,
    customer_name TEXT    NOT NULL,
    segment       TEXT    NOT NULL CHECK (segment IN ('Corporate', 'Small Business', 'Retail')),
    city          TEXT    NOT NULL,
    region        TEXT    NOT NULL CHECK (region IN ('North', 'South', 'East', 'West')),
    signup_date   TEXT    NOT NULL              -- ISO date: YYYY-MM-DD
);

CREATE TABLE products (
    product_id   INTEGER PRIMARY KEY,
    product_name TEXT    NOT NULL UNIQUE,
    category     TEXT    NOT NULL,
    unit_price   REAL    NOT NULL CHECK (unit_price > 0),
    unit_cost    REAL    NOT NULL CHECK (unit_cost > 0)
);

CREATE TABLE orders (
    order_id    INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers (customer_id),
    order_date  TEXT    NOT NULL,               -- ISO date: YYYY-MM-DD
    channel     TEXT    NOT NULL CHECK (channel IN ('Online', 'Store', 'Partner')),
    status      TEXT    NOT NULL CHECK (status IN ('Completed', 'Cancelled', 'Returned'))
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id      INTEGER NOT NULL REFERENCES orders (order_id),
    product_id    INTEGER NOT NULL REFERENCES products (product_id),
    quantity      INTEGER NOT NULL CHECK (quantity > 0),
    unit_price    REAL    NOT NULL,             -- price charged at the time of sale
    discount_pct  REAL    NOT NULL DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100)
);

CREATE INDEX idx_orders_customer ON orders (customer_id);
CREATE INDEX idx_orders_date     ON orders (order_date);
CREATE INDEX idx_items_order     ON order_items (order_id);
CREATE INDEX idx_items_product   ON order_items (product_id);

-- One row per item sold on a COMPLETED order, with revenue, cost and profit
-- already worked out. Cancelled and returned orders are left out here.
CREATE VIEW v_sales AS
SELECT
    oi.order_item_id,
    o.order_id,
    o.order_date,
    strftime('%Y-%m', o.order_date)                               AS order_month,
    o.channel,
    c.customer_id,
    c.customer_name,
    c.segment,
    c.city,
    c.region,
    p.product_id,
    p.product_name,
    p.category,
    oi.quantity,
    oi.discount_pct,
    oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)   AS revenue,
    oi.quantity * p.unit_cost                                     AS cost,
    oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)
        - oi.quantity * p.unit_cost                               AS profit
FROM order_items AS oi
JOIN orders      AS o ON o.order_id    = oi.order_id
JOIN customers   AS c ON c.customer_id = o.customer_id
JOIN products    AS p ON p.product_id  = oi.product_id
WHERE o.status = 'Completed';
