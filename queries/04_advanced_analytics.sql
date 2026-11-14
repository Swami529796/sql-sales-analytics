-- =============================================================================
-- 04 Advanced analytics: year-on-year, RFM, cohorts, Pareto, basket analysis
-- =============================================================================

-- Q21: Year-on-year revenue by month (self-join on the same month last year)
WITH monthly AS (
    SELECT substr(order_month, 1, 4) AS year, substr(order_month, 6, 2) AS month, SUM(revenue) AS revenue
    FROM v_sales
    GROUP BY order_month
)
SELECT
    this_year.month,
    ROUND(last_year.revenue)                                                      AS revenue_2025,
    ROUND(this_year.revenue)                                                      AS revenue_2026,
    ROUND(100.0 * (this_year.revenue - last_year.revenue) / last_year.revenue, 1) AS yoy_growth_pct
FROM monthly AS this_year
JOIN monthly AS last_year
  ON last_year.month = this_year.month
 AND CAST(last_year.year AS INTEGER) = CAST(this_year.year AS INTEGER) - 1
ORDER BY this_year.month;

-- Q22: Which weekday sells the most?
SELECT
    CASE strftime('%w', order_date)
        WHEN '0' THEN 'Sunday'   WHEN '1' THEN 'Monday'   WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday' WHEN '4' THEN 'Thursday' WHEN '5' THEN 'Friday'
        ELSE 'Saturday'
    END                                               AS weekday,
    COUNT(DISTINCT order_id)                          AS orders,
    ROUND(SUM(revenue))                               AS revenue,
    ROUND(SUM(revenue) / COUNT(DISTINCT order_date))  AS avg_revenue_per_day
FROM v_sales
GROUP BY strftime('%w', order_date)
ORDER BY strftime('%w', order_date);

-- Q23: RFM segmentation (Recency, Frequency, Monetary)
-- Each customer gets a 1-5 score on each measure; the scores decide the segment.
WITH today AS (
    SELECT MAX(order_date) AS as_of FROM orders
),
rfm AS (
    SELECT
        customer_id,
        CAST(julianday((SELECT as_of FROM today)) - julianday(MAX(order_date)) AS INTEGER) AS recency_days,
        COUNT(DISTINCT order_id)                                                           AS frequency,
        SUM(revenue)                                                                       AS monetary
    FROM v_sales
    GROUP BY customer_id
),
scored AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS r,   -- most recent buyers score 5
        NTILE(5) OVER (ORDER BY frequency)         AS f,
        NTILE(5) OVER (ORDER BY monetary)          AS m
    FROM rfm
),
labelled AS (
    SELECT *,
        CASE
            WHEN r >= 4 AND f >= 4 AND m >= 4 THEN '1. Champions'
            WHEN f >= 4 AND r >= 3            THEN '2. Loyal'
            WHEN r >= 4 AND f <= 2            THEN '3. New / promising'
            WHEN r <= 2 AND f >= 3 AND m >= 3 THEN '4. At risk'
            WHEN r <= 2 AND f <= 2            THEN '6. Lost'
            ELSE                                   '5. Needs attention'
        END AS rfm_segment
    FROM scored
)
SELECT
    rfm_segment,
    COUNT(*)                                                 AS customers,
    ROUND(AVG(recency_days))                                 AS avg_recency_days,
    ROUND(AVG(frequency), 1)                                 AS avg_orders,
    ROUND(SUM(monetary))                                     AS revenue,
    ROUND(100.0 * SUM(monetary) / SUM(SUM(monetary)) OVER (), 1) AS revenue_share_pct
FROM labelled
GROUP BY rfm_segment
ORDER BY rfm_segment;

-- Q24: Cohort retention - share of each monthly cohort that buys again later
-- Of the customers who first bought in a month, what % bought 1, 2, 3 and 6 months later?
WITH first_order AS (
    SELECT customer_id, MIN(order_month) AS cohort
    FROM v_sales
    GROUP BY customer_id
),
activity AS (
    SELECT DISTINCT
        f.cohort,
        s.customer_id,
        (CAST(substr(s.order_month, 1, 4) AS INTEGER) - CAST(substr(f.cohort, 1, 4) AS INTEGER)) * 12
          + CAST(substr(s.order_month, 6, 2) AS INTEGER) - CAST(substr(f.cohort, 6, 2) AS INTEGER) AS months_later
    FROM v_sales AS s
    JOIN first_order AS f ON f.customer_id = s.customer_id
)
SELECT
    cohort,
    COUNT(DISTINCT CASE WHEN months_later = 0 THEN customer_id END) AS customers,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN months_later = 1 THEN customer_id END)
          / COUNT(DISTINCT CASE WHEN months_later = 0 THEN customer_id END)) AS month_1_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN months_later = 2 THEN customer_id END)
          / COUNT(DISTINCT CASE WHEN months_later = 0 THEN customer_id END)) AS month_2_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN months_later = 3 THEN customer_id END)
          / COUNT(DISTINCT CASE WHEN months_later = 0 THEN customer_id END)) AS month_3_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN months_later = 6 THEN customer_id END)
          / COUNT(DISTINCT CASE WHEN months_later = 0 THEN customer_id END)) AS month_6_pct
FROM activity
GROUP BY cohort
ORDER BY cohort
LIMIT 12;

-- Q25: Pareto (80/20) - how few customers bring in 80% of revenue?
WITH customer_sales AS (
    SELECT customer_id, SUM(revenue) AS revenue
    FROM v_sales
    GROUP BY customer_id
),
running AS (
    SELECT
        revenue,
        ROW_NUMBER() OVER (ORDER BY revenue DESC)                      AS position,
        COUNT(*)     OVER ()                                           AS total_customers,
        SUM(revenue) OVER (ORDER BY revenue DESC, customer_id)         AS running_revenue,
        SUM(revenue) OVER ()                                           AS total_revenue
    FROM customer_sales
)
SELECT
    MIN(position)                                       AS customers_needed,
    MAX(total_customers)                                AS total_customers,
    ROUND(100.0 * MIN(position) / MAX(total_customers), 1) AS pct_of_customers,
    80                                                  AS pct_of_revenue
FROM running
WHERE running_revenue >= 0.8 * total_revenue;

-- Q26: Market basket - which pairs of products are bought together most often?
SELECT
    a.product_name               AS product_a,
    b.product_name               AS product_b,
    COUNT(DISTINCT a.order_id)   AS orders_together
FROM v_sales AS a
JOIN v_sales AS b
  ON b.order_id = a.order_id
 AND b.product_id > a.product_id        -- each pair once, never a product with itself
GROUP BY a.product_id, b.product_id, a.product_name, b.product_name
ORDER BY orders_together DESC
LIMIT 10;

-- Q27: Do discounts pay off? Volume and margin at each discount level
SELECT
    discount_pct,
    COUNT(*)                                          AS line_items,
    ROUND(AVG(quantity), 2)                           AS avg_quantity,
    ROUND(SUM(revenue))                               AS revenue,
    ROUND(100.0 * SUM(profit) / SUM(revenue), 1)      AS margin_pct
FROM v_sales
GROUP BY discount_pct
ORDER BY discount_pct;
