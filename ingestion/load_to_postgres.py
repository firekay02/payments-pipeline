"""Load CSVs from data/raw/ into Postgres. Safe to re-run (idempotent).

- Skips rows whose amount is not a number (counted as bad rows).
- Duplicate transaction_ids are ignored with ON CONFLICT DO NOTHING.
"""
import csv
import logging
import os
from pathlib import Path

import psycopg2
from dotenv import load_dotenv

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
log = logging.getLogger("load")
RAW = Path(__file__).resolve().parent.parent / "data" / "raw"


def connect():
    load_dotenv()
    return psycopg2.connect(
        host=os.getenv("POSTGRES_HOST", "localhost"),
        port=os.getenv("POSTGRES_PORT", "5432"),
        dbname=os.environ["POSTGRES_DB"],
        user=os.environ["POSTGRES_USER"],
        password=os.environ["POSTGRES_PASSWORD"],
    )


def read(path):
    with open(path, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def load_dimension(cur, table, key, rows):
    cols = list(rows[0].keys())
    sql = (f"INSERT INTO {table} ({', '.join(cols)}) VALUES ({', '.join(['%s'] * len(cols))}) "
           f"ON CONFLICT ({key}) DO NOTHING")
    cur.executemany(sql, [tuple(r[c] for c in cols) for r in rows])


def load_transactions(cur, path):
    good, bad = [], 0
    for r in read(path):
        try:
            amount = float(r["amount"])
        except ValueError:
            bad += 1
            continue
        good.append((r["transaction_id"], r["customer_id"], r["merchant_id"], r["channel"],
                     amount, float(r["fee"]), r["status"], r["created_at"]))
    cur.executemany(
        """INSERT INTO raw_transactions
           (transaction_id, customer_id, merchant_id, channel, amount, fee, status, created_at)
           VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
           ON CONFLICT (transaction_id) DO NOTHING""",
        good,
    )
    log.info("%s: %d valid rows sent, %d bad rows skipped", path.name, len(good), bad)


def main():
    with connect() as conn, conn.cursor() as cur:
        load_dimension(cur, "raw_customers", "customer_id", read(RAW / "customers.csv"))
        load_dimension(cur, "raw_merchants", "merchant_id", read(RAW / "merchants.csv"))
        for path in sorted(RAW.glob("transactions_*.csv")):
            load_transactions(cur, path)
        cur.execute("SELECT COUNT(*) FROM raw_transactions")
        log.info("raw_transactions now has %d rows", cur.fetchone()[0])


if __name__ == "__main__":
    main()
