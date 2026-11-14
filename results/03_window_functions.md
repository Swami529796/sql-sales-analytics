# Results: 03_window_functions.sql

## Q13: Running total of revenue within each year

| order_month | revenue | year_to_date |
|---|---|---|
| 2025-01 | 10,454,625 | 10,454,625 |
| 2025-02 | 11,016,850 | 21,471,475 |
| 2025-03 | 11,997,405 | 33,468,880 |
| 2025-04 | 12,333,708 | 45,802,588 |
| 2025-05 | 12,902,778 | 58,705,365 |
| 2025-06 | 10,115,478 | 68,820,843 |
| 2025-07 | 12,467,175 | 81,288,018 |
| 2025-08 | 13,487,790 | 94,775,808 |
| 2025-09 | 10,589,718 | 105,365,525 |
| 2025-10 | 14,249,680 | 119,615,205 |
| 2025-11 | 19,090,663 | 138,705,868 |
| 2025-12 | 16,825,768 | 155,531,635 |
| 2026-01 | 12,799,813 | 12,799,813 |
| 2026-02 | 13,249,238 | 26,049,050 |
| 2026-03 | 15,495,045 | 41,544,095 |
| 2026-04 | 13,226,243 | 54,770,338 |
| 2026-05 | 10,475,423 | 65,245,760 |
| 2026-06 | 13,502,100 | 78,747,860 |

## Q14: Month-on-month growth using LAG

| order_month | revenue | previous_month | growth_pct |
|---|---|---|---|
| 2025-01 | 10,454,625 |  |  |
| 2025-02 | 11,016,850 | 10,454,625 | 5.4 |
| 2025-03 | 11,997,405 | 11,016,850 | 8.9 |
| 2025-04 | 12,333,708 | 11,997,405 | 2.8 |
| 2025-05 | 12,902,778 | 12,333,708 | 4.6 |
| 2025-06 | 10,115,478 | 12,902,778 | -21.6 |
| 2025-07 | 12,467,175 | 10,115,478 | 23.2 |
| 2025-08 | 13,487,790 | 12,467,175 | 8.2 |
| 2025-09 | 10,589,718 | 13,487,790 | -21.5 |
| 2025-10 | 14,249,680 | 10,589,718 | 34.6 |
| 2025-11 | 19,090,663 | 14,249,680 | 34 |
| 2025-12 | 16,825,768 | 19,090,663 | -11.9 |
| 2026-01 | 12,799,813 | 16,825,768 | -23.9 |
| 2026-02 | 13,249,238 | 12,799,813 | 3.5 |
| 2026-03 | 15,495,045 | 13,249,238 | 17 |
| 2026-04 | 13,226,243 | 15,495,045 | -14.6 |
| 2026-05 | 10,475,423 | 13,226,243 | -20.8 |
| 2026-06 | 13,502,100 | 10,475,423 | 28.9 |

## Q15: Three-month moving average (smooths out one-off spikes)

| order_month | revenue | moving_avg_3m |
|---|---|---|
| 2025-01 | 10,454,625 | 10,454,625 |
| 2025-02 | 11,016,850 | 10,735,738 |
| 2025-03 | 11,997,405 | 11,156,293 |
| 2025-04 | 12,333,708 | 11,782,654 |
| 2025-05 | 12,902,778 | 12,411,297 |
| 2025-06 | 10,115,478 | 11,783,988 |
| 2025-07 | 12,467,175 | 11,828,477 |
| 2025-08 | 13,487,790 | 12,023,481 |
| 2025-09 | 10,589,718 | 12,181,561 |
| 2025-10 | 14,249,680 | 12,775,729 |
| 2025-11 | 19,090,663 | 14,643,353 |
| 2025-12 | 16,825,768 | 16,722,037 |
| 2026-01 | 12,799,813 | 16,238,748 |
| 2026-02 | 13,249,238 | 14,291,606 |
| 2026-03 | 15,495,045 | 13,848,032 |
| 2026-04 | 13,226,243 | 13,990,175 |
| 2026-05 | 10,475,423 | 13,065,570 |
| 2026-06 | 13,502,100 | 12,401,255 |

## Q16: Top 3 products in every category (RANK inside a partition)

| category | rank_in_category | product_name | revenue |
|---|---|---|---|
| Accessories | 1 | Headset Pro | 4,727,310 |
| Accessories | 2 | Mechanical Keyboard | 3,885,300 |
| Accessories | 3 | USB-C Hub | 3,163,320 |
| Computers | 1 | Laptop Air 13 | 52,794,500 |
| Computers | 2 | Laptop Pro 15 | 44,850,000 |
| Computers | 3 | Desktop Tower | 24,326,400 |
| Displays | 1 | Monitor 24in | 16,096,550 |
| Displays | 2 | Monitor 27in 4K | 11,629,200 |
| Displays | 3 | Projector HD | 6,312,600 |
| Networking | 1 | Mesh WiFi Kit | 4,782,500 |
| Networking | 2 | WiFi Router | 3,556,215 |
| Networking | 3 | Network Switch 16p | 2,753,560 |
| Peripherals | 1 | Laser Printer | 7,313,075 |
| Peripherals | 2 | Inkjet Printer | 5,614,830 |
| Peripherals | 3 | UPS 1kVA | 4,301,680 |
| Storage | 1 | External SSD 1TB | 7,530,240 |
| Storage | 2 | NAS 2-Bay | 4,967,550 |
| Storage | 3 | External HDD 2TB | 4,445,560 |

## Q17: Best customer in each region (ROW_NUMBER to pick exactly one)

| region | customer_name | revenue |
|---|---|---|
| North | Deltaforge Traders | 9,992,413 |
| West | Ironbridge Systems | 5,230,418 |
| South | Umberfield Technologies | 4,871,580 |
| East | Redbrook Agencies | 4,342,895 |

## Q18: Each category's share of total revenue

| category | revenue | share_pct |
|---|---|---|
| Computers | 132,371,500 | 56.5 |
| Displays | 34,038,350 | 14.5 |
| Peripherals | 23,898,755 | 10.2 |
| Storage | 17,990,468 | 7.7 |
| Accessories | 14,888,148 | 6.4 |
| Networking | 11,092,275 | 4.7 |

## Q19: Customer spend quartiles with NTILE

| quartile | customers | lowest_spend | highest_spend | total_revenue |
|---|---|---|---|---|
| 1 | 74 | 851,970 | 9,992,413 | 158,811,848 |
| 2 | 74 | 423,545 | 846,680 | 46,629,980 |
| 3 | 74 | 185,005 | 420,585 | 21,576,938 |
| 4 | 74 | 6,400 | 184,515 | 7,260,730 |

## Q20: Average number of days between a customer's orders (LAG per customer)

| segment | repeat_orders | avg_days_between_orders |
|---|---|---|
| Corporate | 1156 | 21.9 |
| Small Business | 1049 | 32.8 |
| Retail | 1173 | 35.1 |
