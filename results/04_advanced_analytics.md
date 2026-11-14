# Results: 04_advanced_analytics.sql

## Q21: Year-on-year revenue by month (self-join on the same month last year)

| month | revenue_2025 | revenue_2026 | yoy_growth_pct |
|---|---|---|---|
| 01 | 10,454,625 | 12,799,813 | 22.4 |
| 02 | 11,016,850 | 13,249,238 | 20.3 |
| 03 | 11,997,405 | 15,495,045 | 29.2 |
| 04 | 12,333,708 | 13,226,243 | 7.2 |
| 05 | 12,902,778 | 10,475,423 | -18.8 |
| 06 | 10,115,478 | 13,502,100 | 33.5 |

## Q22: Which weekday sells the most?

| weekday | orders | revenue | avg_revenue_per_day |
|---|---|---|---|
| Sunday | 326 | 19,455,743 | 259,410 |
| Monday | 568 | 36,609,773 | 469,356 |
| Tuesday | 529 | 34,315,648 | 439,944 |
| Wednesday | 563 | 34,859,453 | 446,916 |
| Thursday | 539 | 34,460,450 | 441,801 |
| Friday | 562 | 35,039,818 | 449,228 |
| Saturday | 587 | 39,538,613 | 506,905 |

## Q23: RFM segmentation (Recency, Frequency, Monetary)

| rfm_segment | customers | avg_recency_days | avg_orders | revenue | revenue_share_pct |
|---|---|---|---|---|---|
| 1. Champions | 56 | 9 | 28.6 | 113,355,718 | 48.4 |
| 2. Loyal | 29 | 31 | 20 | 39,619,200 | 16.9 |
| 3. New / promising | 27 | 14 | 4.4 | 5,769,248 | 2.5 |
| 4. At risk | 41 | 89 | 12.9 | 35,553,970 | 15.2 |
| 5. Needs attention | 74 | 35 | 7.5 | 25,163,060 | 10.7 |
| 6. Lost | 69 | 114 | 4.2 | 14,818,300 | 6.3 |

## Q24: Cohort retention - share of each monthly cohort that buys again later

| cohort | customers | month_1_pct | month_2_pct | month_3_pct | month_6_pct |
|---|---|---|---|---|---|
| 2025-01 | 88 | 55 | 69 | 51 | 55 |
| 2025-02 | 39 | 59 | 49 | 49 | 49 |
| 2025-03 | 30 | 63 | 37 | 37 | 30 |
| 2025-04 | 12 | 50 | 67 | 67 | 50 |
| 2025-05 | 17 | 47 | 35 | 41 | 41 |
| 2025-06 | 10 | 30 | 50 | 50 | 50 |
| 2025-07 | 10 | 40 | 70 | 60 | 60 |
| 2025-08 | 11 | 18 | 18 | 55 | 36 |
| 2025-09 | 8 | 75 | 50 | 38 | 63 |
| 2025-10 | 6 | 83 | 67 | 33 | 50 |
| 2025-11 | 11 | 55 | 36 | 27 | 36 |
| 2025-12 | 8 | 38 | 25 | 38 | 25 |

## Q25: Pareto (80/20) - how few customers bring in 80% of revenue?

| customers_needed | total_customers | pct_of_customers | pct_of_revenue |
|---|---|---|---|
| 114 | 296 | 38.5 | 80 |

## Q26: Market basket - which pairs of products are bought together most often?

| product_a | product_b | orders_together |
|---|---|---|
| Wireless Mouse | USB Drive 64GB | 66 |
| Monitor 24in | Wireless Mouse | 65 |
| USB-C Hub | USB Drive 64GB | 56 |
| Wireless Mouse | Mechanical Keyboard | 54 |
| Mechanical Keyboard | USB Drive 64GB | 54 |
| Wireless Mouse | Headset Pro | 52 |
| Monitor 24in | USB-C Hub | 51 |
| Wireless Mouse | USB-C Hub | 51 |
| Laptop Bag | USB Drive 64GB | 49 |
| USB-C Hub | Headset Pro | 47 |

## Q27: Do discounts pay off? Volume and margin at each discount level

| discount_pct | line_items | avg_quantity | revenue | margin_pct |
|---|---|---|---|---|
| 0 | 4070 | 3.01 | 143,821,150 | 23.5 |
| 5 | 1292 | 2.95 | 46,643,670 | 19.1 |
| 10 | 944 | 2.95 | 31,859,595 | 14.7 |
| 15 | 409 | 2.91 | 11,955,080 | 9.8 |
