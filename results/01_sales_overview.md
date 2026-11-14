# Results: 01_sales_overview.sql

## Q01: Monthly revenue, orders and average order value

| order_month | orders | revenue | avg_order_value |
|---|---|---|---|
| 2025-01 | 176 | 10,454,625 | 59,401 |
| 2025-02 | 167 | 11,016,850 | 65,969 |
| 2025-03 | 202 | 11,997,405 | 59,393 |
| 2025-04 | 167 | 12,333,708 | 73,855 |
| 2025-05 | 194 | 12,902,778 | 66,509 |
| 2025-06 | 174 | 10,115,478 | 58,135 |
| 2025-07 | 190 | 12,467,175 | 65,617 |
| 2025-08 | 203 | 13,487,790 | 66,442 |
| 2025-09 | 178 | 10,589,718 | 59,493 |
| 2025-10 | 238 | 14,249,680 | 59,873 |
| 2025-11 | 263 | 19,090,663 | 72,588 |
| 2025-12 | 251 | 16,825,768 | 67,035 |
| 2026-01 | 204 | 12,799,813 | 62,744 |
| 2026-02 | 195 | 13,249,238 | 67,945 |
| 2026-03 | 228 | 15,495,045 | 67,961 |
| 2026-04 | 213 | 13,226,243 | 62,095 |
| 2026-05 | 211 | 10,475,423 | 49,647 |
| 2026-06 | 220 | 13,502,100 | 61,373 |

## Q02: Revenue, profit and margin by product category

| category | units | revenue | profit | margin_pct |
|---|---|---|---|---|
| Computers | 2573 | 132,371,500 | 23,357,500 | 17.6 |
| Displays | 2130 | 34,038,350 | 7,288,950 | 21.4 |
| Peripherals | 3297 | 23,898,755 | 5,408,355 | 22.6 |
| Storage | 3776 | 17,990,468 | 3,854,148 | 21.4 |
| Accessories | 6602 | 14,888,148 | 5,911,128 | 39.7 |
| Networking | 1678 | 11,092,275 | 2,784,875 | 25.1 |

## Q03: Top 10 products by revenue

| product_name | category | units | revenue |
|---|---|---|---|
| Laptop Air 13 | Computers | 998 | 52,794,500 |
| Laptop Pro 15 | Computers | 595 | 44,850,000 |
| Desktop Tower | Computers | 596 | 24,326,400 |
| Monitor 24in | Displays | 1447 | 16,096,550 |
| Monitor 27in 4K | Displays | 501 | 11,629,200 |
| Mini PC | Computers | 384 | 10,400,600 |
| External SSD 1TB | Storage | 1047 | 7,530,240 |
| Laser Printer | Peripherals | 521 | 7,313,075 |
| Projector HD | Displays | 182 | 6,312,600 |
| Inkjet Printer | Peripherals | 746 | 5,614,830 |

## Q04: Sales channel mix by region (pivot with conditional aggregation)

| region | online | store | partner | total |
|---|---|---|---|---|
| South | 30,518,450 | 21,637,515 | 10,537,500 | 62,693,465 |
| North | 30,708,990 | 19,770,230 | 11,331,985 | 61,811,205 |
| West | 25,120,655 | 21,703,913 | 10,803,188 | 57,627,755 |
| East | 28,189,400 | 16,252,988 | 7,704,683 | 52,147,070 |

## Q05: Cancellation and return rate by channel

| channel | orders | cancelled_pct | returned_pct |
|---|---|---|---|
| Online | 2015 | 4.3 | 4.9 |
| Store | 1312 | 5.3 | 3.7 |
| Partner | 717 | 4.2 | 5.3 |

## Q06: Products that have never been sold on a completed order (anti-join)

| product_name | category |
|---|---|
