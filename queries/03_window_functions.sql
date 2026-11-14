-- =============================================================================
-- 03 Window functions: running totals, LAG, ranking, moving averages, NTILE
-- =============================================================================

-- Q13: Running total of revenue within each year
WITH monthly AS (
    SELECT order_month, substr(order_month, 1, 4) AS year, SUM(revenue) AS revenue
    FROM v_sales
    GROUP BY order_month
)
SELECT
    order_month,
    ROUND(revenue)                                                       AS revenue,
    ROUND(SUM(revenue) OVER (PARTITION BY year ORDER BY order_month))    AS year_to_date
FROM monthly
ORDER BY order_month;

-- Q14: Month-on-month growth using LAG
WITH monthly AS (
    SELECT order_month, SUM(revenue) AS revenue
    FROM v_sales
    GROUP BY order_month
)
SELECT
    order_month,
    ROUND(revenue)                                        AS revenue,
    ROUND(LAG(revenue) OVER (ORDER BY order_month))       AS previous_month,
    ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY order_month))
          / LAG(revenue) OVER (ORDER BY order_month), 1)  AS growth_pct
FROM monthly
ORDER BY order_month;

-- Q15: Three-month moving average (smooths out one-off spikes)
WITH monthly AS (
    SELECT order_month, SUM(revenue) AS revenue
    FROM v_sales
    GROUP BY order_month
)
SELECT
    order_month,
    ROUND(revenue) AS revenue,
    ROUND(AVG(revenue) OVER (ORDER BY order_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)) AS moving_avg_3m
FROM monthly
ORDER BY order_month;

-- Q16: Top 3 products in every category (RANK inside a partition)
WITH product_sales AS (
    SELECT category, product_name, SUM(revenue) AS revenue
    FROM v_sales
    GROUP BY category, product_name
),
ranked AS (
    SELECT *, RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rank_in_category
    FROM product_sales
)
SELECT category, rank_in_category, product_name, ROUND(revenue) AS revenue
FROM ranked
WHERE rank_in_category <= 3
ORDER BY category, rank_in_category;

-- Q17: Best customer in each region (ROW_NUMBER to pick exactly one)
WITH customer_sales AS (
    SELECT region, customer_name, SUM(revenue) AS revenue
    FROM v_sales
    GROUP BY region, customer_id, customer_name
),
ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY region ORDER BY revenue DESC) AS position
    FROM customer_sales
)
SELECT region, customer_name, ROUND(revenue) AS revenue
FROM ranked
WHERE position = 1
ORDER BY revenue DESC;

-- Q18: Each category's share of total revenue
SELECT
    category,
    ROUND(SUM(revenue))                                            AS revenue,
    ROUND(100.0 * SUM(revenue) / SUM(SUM(revenue)) OVER (), 1)     AS share_pct
FROM v_sales
GROUP BY category
ORDER BY revenue DESC;

-- Q19: Customer spend quartiles with NTILE
WITH customer_sales AS (
    SELECT customer_id, SUM(revenue) AS revenue
    FROM v_sales
    GROUP BY customer_id
),
quartiles AS (
    SELECT *, NTILE(4) OVER (ORDER BY revenue DESC) AS quartile
    FROM customer_sales
)
SELECT
    quartile,
    COUNT(*)                 AS customers,
    ROUND(MIN(revenue))      AS lowest_spend,
    ROUND(MAX(revenue))      AS highest_spend,
    ROUND(SUM(revenue))      AS total_revenue
FROM quartiles
GROUP BY quartile
ORDER BY quartile;

-- Q20: Average number of days between a customer's orders (LAG per customer)
WITH customer_orders AS (
    SELECT DISTINCT customer_id, segment, order_id, order_date
    FROM v_sales
),
gaps AS (
    SELECT
        segment,
        julianday(order_date)
            - julianday(LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date, order_id)) AS gap_days
    FROM customer_orders
)
SELECT segment, COUNT(gap_days) AS repeat_orders, ROUND(AVG(gap_days), 1) AS avg_days_between_orders
FROM gaps
WHERE gap_days IS NOT NULL
GROUP BY segment
ORDER BY avg_days_between_orders;
