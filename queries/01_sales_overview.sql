-- =============================================================================
-- 01 Sales overview: aggregation, grouping, joins, CASE
-- =============================================================================

-- Q01: Monthly revenue, orders and average order value
SELECT
    order_month,
    COUNT(DISTINCT order_id)                           AS orders,
    ROUND(SUM(revenue))                                AS revenue,
    ROUND(SUM(revenue) / COUNT(DISTINCT order_id))     AS avg_order_value
FROM v_sales
GROUP BY order_month
ORDER BY order_month;

-- Q02: Revenue, profit and margin by product category
SELECT
    category,
    SUM(quantity)                                      AS units,
    ROUND(SUM(revenue))                                AS revenue,
    ROUND(SUM(profit))                                 AS profit,
    ROUND(100.0 * SUM(profit) / SUM(revenue), 1)       AS margin_pct
FROM v_sales
GROUP BY category
ORDER BY revenue DESC;

-- Q03: Top 10 products by revenue
SELECT
    product_name,
    category,
    SUM(quantity)            AS units,
    ROUND(SUM(revenue))      AS revenue
FROM v_sales
GROUP BY product_id, product_name, category
ORDER BY revenue DESC
LIMIT 10;

-- Q04: Sales channel mix by region (pivot with conditional aggregation)
SELECT
    region,
    ROUND(SUM(CASE WHEN channel = 'Online'  THEN revenue ELSE 0 END)) AS online,
    ROUND(SUM(CASE WHEN channel = 'Store'   THEN revenue ELSE 0 END)) AS store,
    ROUND(SUM(CASE WHEN channel = 'Partner' THEN revenue ELSE 0 END)) AS partner,
    ROUND(SUM(revenue))                                               AS total
FROM v_sales
GROUP BY region
ORDER BY total DESC;

-- Q05: Cancellation and return rate by channel
-- Uses the orders table directly because v_sales only holds completed orders.
SELECT
    channel,
    COUNT(*)                                                                  AS orders,
    ROUND(100.0 * SUM(status = 'Cancelled') / COUNT(*), 1)                    AS cancelled_pct,
    ROUND(100.0 * SUM(status = 'Returned')  / COUNT(*), 1)                    AS returned_pct
FROM orders
GROUP BY channel
ORDER BY orders DESC;

-- Q06: Products that have never been sold on a completed order (anti-join)
SELECT p.product_name, p.category
FROM products AS p
LEFT JOIN v_sales AS s ON s.product_id = p.product_id
WHERE s.product_id IS NULL
ORDER BY p.product_name;
