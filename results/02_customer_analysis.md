# Results: 02_customer_analysis.sql

## Q07: Top 10 customers by lifetime revenue

| customer_name | segment | region | orders | revenue |
|---|---|---|---|---|
| Deltaforge Traders | Corporate | North | 107 | 9,992,413 |
| Yellowpine Technologies | Corporate | North | 84 | 7,632,415 |
| Ironbridge Systems | Corporate | West | 46 | 5,230,418 |
| Valewood Technologies | Corporate | North | 60 | 4,979,405 |
| Umberfield Technologies | Corporate | South | 40 | 4,871,580 |
| Zenhaven Technologies | Corporate | North | 49 | 4,463,790 |
| Redbrook Agencies | Corporate | East | 40 | 4,342,895 |
| Silverline Enterprises | Corporate | South | 39 | 4,258,925 |
| Yellowpine Supplies | Corporate | East | 29 | 3,901,013 |
| Crestline Retail | Corporate | East | 26 | 3,764,705 |

## Q08: Segment summary - customers, revenue and revenue per customer

| segment | customers | revenue | revenue_per_customer | orders_per_customer |
|---|---|---|---|---|
| Corporate | 73 | 130,643,033 | 1,789,631 | 16.8 |
| Retail | 117 | 54,681,525 | 467,363 | 11 |
| Small Business | 106 | 48,954,938 | 461,839 | 10.9 |

## Q09: New vs returning customers per month

| order_month | new_customers | returning_customers |
|---|---|---|
| 2025-01 | 88 | 0 |
| 2025-02 | 39 | 48 |
| 2025-03 | 30 | 84 |
| 2025-04 | 12 | 83 |
| 2025-05 | 17 | 88 |
| 2025-06 | 10 | 90 |
| 2025-07 | 10 | 101 |
| 2025-08 | 11 | 109 |
| 2025-09 | 8 | 101 |
| 2025-10 | 6 | 121 |
| 2025-11 | 11 | 120 |
| 2025-12 | 8 | 127 |
| 2026-01 | 10 | 124 |
| 2026-02 | 10 | 109 |
| 2026-03 | 10 | 131 |
| 2026-04 | 9 | 126 |
| 2026-05 | 4 | 129 |
| 2026-06 | 3 | 132 |

## Q10: Customers at risk - bought before, but nothing in the last 90 days

| customer_name | segment | last_order_date | days_since_last_order | lifetime_revenue |
|---|---|---|---|---|
| Evermark Retail | Corporate | 2026-03-25 | 97 | 1,305,873 |
| Highmoor Associates | Corporate | 2026-03-21 | 101 | 1,180,543 |
| Yellowpine Systems | Corporate | 2026-01-27 | 154 | 1,090,155 |
| Maplecrest Enterprises | Corporate | 2026-03-17 | 105 | 1,017,035 |
| Westmark Solutions | Corporate | 2025-12-25 | 187 | 760,120 |
| Valewood Industries | Small Business | 2026-03-28 | 94 | 686,095 |
| Pinewood Associates | Corporate | 2026-02-07 | 143 | 663,528 |
| Valewood Traders | Retail | 2025-11-08 | 234 | 590,065 |
| Deltaforge Industries | Retail | 2026-03-27 | 95 | 587,933 |
| Northgate Retail | Corporate | 2025-12-17 | 195 | 564,283 |

## Q11: Customers who signed up but never placed a completed order

| customer_name | segment | region | signup_date |
|---|---|---|---|
| Oakridge Associates | Retail | West | 2025-05-24 |
| Jadestone Solutions | Corporate | East | 2026-02-16 |
| Silverline Distributors | Retail | West | 2026-02-16 |
| Maplecrest Solutions | Small Business | North | 2026-03-18 |

## Q12: Customers who spend more than twice the average customer

| customer_name | segment | revenue |
|---|---|---|
| Deltaforge Traders | Corporate | 9,992,413 |
| Yellowpine Technologies | Corporate | 7,632,415 |
| Ironbridge Systems | Corporate | 5,230,418 |
| Valewood Technologies | Corporate | 4,979,405 |
| Umberfield Technologies | Corporate | 4,871,580 |
| Zenhaven Technologies | Corporate | 4,463,790 |
| Redbrook Agencies | Corporate | 4,342,895 |
| Silverline Enterprises | Corporate | 4,258,925 |
| Yellowpine Supplies | Corporate | 3,901,013 |
| Crestline Retail | Corporate | 3,764,705 |
