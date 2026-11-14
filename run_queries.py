"""Build the SQLite database and run every query in the queries folder.

Uses only the Python standard library, so there is nothing to install.

    python run_queries.py            # build sales.db, run all queries, save results
    python run_queries.py --show 14  # also print the result of query Q14

Each query's result is saved as a Markdown table in the results folder.
"""
from __future__ import annotations

import argparse
import csv
import re
import sqlite3
from pathlib import Path

HERE = Path(__file__).parent
DATABASE = HERE / "sales.db"
TABLES = ["customers", "products", "orders", "order_items"]  # load order respects foreign keys
MAX_ROWS = 20


def build_database() -> sqlite3.Connection:
    """Create sales.db from schema.sql and the CSV files in data/."""
    DATABASE.unlink(missing_ok=True)
    connection = sqlite3.connect(DATABASE)
    connection.execute("PRAGMA foreign_keys = ON")
    connection.executescript((HERE / "schema.sql").read_text(encoding="utf-8"))
    for table in TABLES:
        with (HERE / "data" / f"{table}.csv").open(newline="", encoding="utf-8") as handle:
            reader = csv.reader(handle)
            header = next(reader)
            placeholders = ", ".join("?" for _ in header)
            connection.executemany(
                f"INSERT INTO {table} ({', '.join(header)}) VALUES ({placeholders})", reader)
    connection.commit()
    return connection


def split_queries(text: str) -> list[tuple[str, str, str]]:
    """Return (number, title, sql) for every block that starts with '-- Qnn: title'."""
    queries = []
    blocks = re.split(r"^-- (Q\d+): (.+)$", text, flags=re.MULTILINE)
    for number, title, body in zip(blocks[1::3], blocks[2::3], blocks[3::3]):
        queries.append((number, title.strip(), body.strip()))
    return queries


def to_markdown(columns: list[str], rows: list[tuple]) -> str:
    def cell(value: object) -> str:
        if value is None:
            return ""
        if isinstance(value, float):
            return f"{value:,.2f}".rstrip("0").rstrip(".")
        return str(value)

    lines = ["| " + " | ".join(columns) + " |", "|" + "---|" * len(columns)]
    lines += ["| " + " | ".join(cell(value) for value in row) + " |" for row in rows[:MAX_ROWS]]
    if len(rows) > MAX_ROWS:
        lines.append(f"\n*Showing the first {MAX_ROWS} of {len(rows)} rows.*")
    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description="Build sales.db and run all analysis queries.")
    parser.add_argument("--show", type=int, help="print the result of this query number")
    args = parser.parse_args()

    connection = build_database()
    counts = {table: connection.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0] for table in TABLES}
    print("Database built:", ", ".join(f"{table} {count:,}" for table, count in counts.items()))

    results = HERE / "results"
    results.mkdir(exist_ok=True)
    total = 0
    for path in sorted((HERE / "queries").glob("*.sql")):
        sections = [f"# Results: {path.name}\n"]
        for number, title, sql in split_queries(path.read_text(encoding="utf-8")):
            cursor = connection.execute(sql)
            columns = [column[0] for column in cursor.description]
            rows = cursor.fetchall()
            table = to_markdown(columns, rows)
            sections.append(f"## {number}: {title}\n\n{table}\n")
            total += 1
            print(f"  {number}  {len(rows):>3} rows  {title}")
            if args.show == int(number[1:]):
                print("\n" + table + "\n")
        (results / f"{path.stem}.md").write_text("\n".join(sections), encoding="utf-8")
    connection.close()
    print(f"\n{total} queries run. Results saved in: {results}")


if __name__ == "__main__":
    main()
