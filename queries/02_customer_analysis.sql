-- =============================================================================
-- 02 Customer analysis: subqueries, CTEs, HAVING, date arithmetic
-- =============================================================================

-- Q07: Top 10 customers by lifetime revenue
SELECT
    customer_name,
    segment,
    region,
    COUNT(DISTINCT order_id)   AS orders,
    ROUND(SUM(revenue))        AS revenue
FROM v_sales
GROUP BY customer_id, customer_name, segment, region
ORDER BY revenue DESC
LIMIT 10;

-- Q08: Segment summary - customers, revenue and revenue per customer
SELECT
    segment,
    COUNT(DISTINCT customer_id)                             AS customers,
    ROUND(SUM(revenue))                                     AS revenue,
    ROUND(SUM(revenue) / COUNT(DISTINCT customer_id))       AS revenue_per_customer,
    ROUND(1.0 * COUNT(DISTINCT order_id) / COUNT(DISTINCT customer_id), 1) AS orders_per_customer
FROM v_sales
GROUP BY segment
ORDER BY revenue DESC;

-- Q09: New vs returning customers per month
WITH first_order AS (
    SELECT customer_id, MIN(order_month) AS first_month
    FROM v_sales
    GROUP BY customer_id
)
SELECT
    s.order_month,
    COUNT(DISTINCT CASE WHEN s.order_month = f.first_month THEN s.customer_id END) AS new_customers,
    COUNT(DISTINCT CASE WHEN s.order_month > f.first_month THEN s.customer_id END) AS returning_customers
FROM v_sales AS s
JOIN first_order AS f ON f.customer_id = s.customer_id
GROUP BY s.order_month
ORDER BY s.order_month;

-- Q10: Customers at risk - bought before, but nothing in the last 90 days
-- "Today" is the latest order date in the data, so the result is repeatable.
WITH today AS (
    SELECT MAX(order_date) AS as_of FROM orders
),
last_purchase AS (
    SELECT customer_id, customer_name, segment,
           MAX(order_date)        AS last_order_date,
           ROUND(SUM(revenue))    AS lifetime_revenue
    FROM v_sales
    GROUP BY customer_id, customer_name, segment
)
SELECT
    customer_name,
    segment,
    last_order_date,
    CAST(julianday(as_of) - julianday(last_order_date) AS INTEGER) AS days_since_last_order,
    lifetime_revenue
FROM last_purchase, today
WHERE julianday(as_of) - julianday(last_order_date) > 90
ORDER BY lifetime_revenue DESC
LIMIT 10;

-- Q11: Customers who signed up but never placed a completed order
SELECT c.customer_name, c.segment, c.region, c.signup_date
FROM customers AS c
WHERE NOT EXISTS (
    SELECT 1 FROM v_sales AS s WHERE s.customer_id = c.customer_id
)
ORDER BY c.signup_date
LIMIT 10;

-- Q12: Customers who spend more than twice the average customer
SELECT customer_name, segment, ROUND(SUM(revenue)) AS revenue
FROM v_sales
GROUP BY customer_id, customer_name, segment
HAVING SUM(revenue) > 2 * (
    SELECT AVG(customer_revenue)
    FROM (SELECT SUM(revenue) AS customer_revenue FROM v_sales GROUP BY customer_id)
)
ORDER BY revenue DESC
LIMIT 10;
