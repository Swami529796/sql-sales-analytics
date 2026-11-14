"""Create the sample retail dataset as CSV files (repeatable: fixed seed).

All names are made up. Run from the project folder:
    python data/generate_data.py
"""
from __future__ import annotations

import csv
import random
from datetime import date, timedelta
from pathlib import Path

HERE = Path(__file__).parent
START, END = date(2025, 1, 1), date(2026, 6, 30)

CITIES = {
    "North": ["Delhi", "Chandigarh", "Jaipur", "Lucknow"],
    "South": ["Chennai", "Bengaluru", "Hyderabad", "Kochi"],
    "East": ["Kolkata", "Bhubaneswar", "Guwahati", "Patna"],
    "West": ["Mumbai", "Pune", "Ahmedabad", "Surat"],
}
NAME_FIRST = ["Apex", "Bluewave", "Crestline", "Deltaforge", "Evermark", "Fernhill", "Goldleaf", "Highmoor",
              "Ironbridge", "Jadestone", "Kiteway", "Lakefield", "Maplecrest", "Northgate", "Oakridge",
              "Pinewood", "Quillon", "Redbrook", "Silverline", "Tidewater", "Umberfield", "Valewood",
              "Westmark", "Yellowpine", "Zenhaven"]
NAME_LAST = ["Traders", "Enterprises", "Solutions", "Retail", "Industries", "Systems", "Supplies",
             "Distributors", "Associates", "Technologies", "Stores", "Agencies"]
SEGMENTS = [("Corporate", 0.25), ("Small Business", 0.35), ("Retail", 0.40)]
CHANNELS = [("Online", 0.50), ("Store", 0.32), ("Partner", 0.18)]

# name, category, unit price, unit cost
PRODUCTS = [
    ("Laptop Pro 15", "Computers", 78000, 61000), ("Laptop Air 13", "Computers", 55000, 44500),
    ("Desktop Tower", "Computers", 42000, 33000), ("Mini PC", "Computers", 28000, 22500),
    ("Monitor 24in", "Displays", 11500, 8600), ("Monitor 27in 4K", "Displays", 24000, 18200),
    ("Projector HD", "Displays", 36000, 28500), ("Laser Printer", "Peripherals", 14500, 11200),
    ("Inkjet Printer", "Peripherals", 7800, 6100), ("Document Scanner", "Peripherals", 9500, 7000),
    ("Webcam HD", "Peripherals", 3200, 2000), ("Wireless Mouse", "Accessories", 850, 420),
    ("Mechanical Keyboard", "Accessories", 3600, 2150), ("USB-C Hub", "Accessories", 2400, 1400),
    ("Headset Pro", "Accessories", 4200, 2600), ("Laptop Bag", "Accessories", 1500, 780),
    ("WiFi Router", "Networking", 3900, 2700), ("Network Switch 16p", "Networking", 8200, 6100),
    ("Mesh WiFi Kit", "Networking", 12500, 9300), ("External SSD 1TB", "Storage", 7400, 5600),
    ("External HDD 2TB", "Storage", 5600, 4400), ("NAS 2-Bay", "Storage", 21000, 16800),
    ("USB Drive 64GB", "Storage", 650, 330), ("UPS 1kVA", "Peripherals", 6800, 5200),
]
PRODUCT_WEIGHT = [3, 5, 3, 2, 7, 3, 1, 3, 4, 2, 5, 10, 6, 7, 6, 6, 5, 2, 2, 5, 4, 1, 9, 3]


def pick(rng: random.Random, options: list[tuple[str, float]]) -> str:
    return rng.choices([name for name, _ in options], weights=[weight for _, weight in options])[0]


def write(name: str, header: list[str], rows: list[list]) -> None:
    with (HERE / name).open("w", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle)
        writer.writerow(header)
        writer.writerows(rows)
    print(f"{name}: {len(rows):,} rows")


def main() -> None:
    rng = random.Random(42)

    # ---- customers
    names = rng.sample([f"{first} {last}" for first in NAME_FIRST for last in NAME_LAST], 300)
    customers, activity = [], {}
    for customer_id, name in enumerate(names, start=1):
        region = rng.choice(list(CITIES))
        signup = date(2023, 7, 1) + timedelta(days=rng.randint(0, 1000))
        segment = pick(rng, SEGMENTS)
        customers.append([customer_id, name, segment, rng.choice(CITIES[region]), region, signup.isoformat()])
        # a few customers order often, most order rarely
        activity[customer_id] = (signup, min(rng.paretovariate(1.6), 10.0) * (1.5 if segment == "Corporate" else 1.0), segment)

    # ---- products
    products = [[product_id, *row] for product_id, row in enumerate(PRODUCTS, start=1)]

    # ---- orders and order items
    orders, items = [], []
    order_id = item_id = 0
    day = START
    while day <= END:
        months_in = (day.year - START.year) * 12 + day.month - START.month
        growth = 1 + 0.018 * months_in
        season = {10: 1.25, 11: 1.35, 12: 1.15, 3: 1.10}.get(day.month, 1.0)  # festive season and year end
        weekday = 0.55 if day.weekday() == 6 else 1.0
        eligible = [cid for cid, (signup, _, _) in activity.items() if signup <= day]
        weights = [activity[cid][1] for cid in eligible]
        for _ in range(max(0, round(rng.gauss(6.5 * growth * season * weekday, 1.8)))):
            customer_id = rng.choices(eligible, weights=weights)[0]
            segment = activity[customer_id][2]
            order_id += 1
            status = rng.choices(["Completed", "Cancelled", "Returned"], weights=[90, 5, 5])[0]
            orders.append([order_id, customer_id, day.isoformat(), pick(rng, CHANNELS), status])
            for product_id in rng.sample(range(1, len(PRODUCTS) + 1), k=rng.choices([1, 2, 3, 4], [45, 30, 17, 8])[0],
                                         counts=PRODUCT_WEIGHT):
                if any(row[1] == order_id and row[2] == product_id for row in items[-4:]):
                    continue  # same product drawn twice for this order
                item_id += 1
                quantity = rng.randint(2, 8) if segment == "Corporate" else rng.randint(1, 3)
                discount = rng.choices([0, 5, 10, 15], weights=[60, 20, 14, 6])[0]
                items.append([item_id, order_id, product_id, quantity, PRODUCTS[product_id - 1][2], discount])
        day += timedelta(days=1)

    write("customers.csv", ["customer_id", "customer_name", "segment", "city", "region", "signup_date"], customers)
    write("products.csv", ["product_id", "product_name", "category", "unit_price", "unit_cost"], products)
    write("orders.csv", ["order_id", "customer_id", "order_date", "channel", "status"], orders)
    write("order_items.csv", ["order_item_id", "order_id", "product_id", "quantity", "unit_price", "discount_pct"], items)


if __name__ == "__main__":
    main()
