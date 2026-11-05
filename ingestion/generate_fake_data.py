"""Generate fake mobile-money payments data as CSV files in data/raw/.

Standard library only. Adds messy rows on purpose (duplicates, missing amounts)
so the cleaning steps have something to fix.

Usage:  python ingestion/generate_fake_data.py --days 7 --per-day 500
"""
import argparse
import csv
import random
import uuid
from datetime import date, datetime, timedelta
from pathlib import Path

RAW = Path(__file__).resolve().parent.parent / "data" / "raw"
CHANNELS = ["MTN", "Telecel", "AirtelTigo", "card"]
STATUSES = ["success"] * 85 + ["failed"] * 10 + ["pending"] * 5
REGIONS = ["Greater Accra", "Ashanti", "Western", "Eastern", "Northern", "Volta"]
CATEGORIES = ["food", "transport", "utilities", "retail", "airtime"]


def make_customers(n):
    return [{"customer_id": f"C{i:05d}",
             "region": random.choice(REGIONS),
             "signup_date": (date(2025, 1, 1) + timedelta(days=random.randint(0, 600))).isoformat()}
            for i in range(1, n + 1)]


def make_merchants(n):
    return [{"merchant_id": f"M{i:04d}",
             "merchant_name": f"Merchant {i}",
             "category": random.choice(CATEGORIES)}
            for i in range(1, n + 1)]


def make_transactions(day, n, customers, merchants):
    rows = []
    for _ in range(n):
        amount = round(random.uniform(1, 500), 2)
        rows.append({
            "transaction_id": str(uuid.UUID(int=random.getrandbits(128))),
            "customer_id": random.choice(customers)["customer_id"],
            "merchant_id": random.choice(merchants)["merchant_id"],
            "channel": random.choice(CHANNELS),
            "amount": amount,
            "fee": round(amount * 0.01, 2),          # made-up 1% fee
            "status": random.choice(STATUSES),
            "created_at": (datetime.combine(day, datetime.min.time())
                           + timedelta(seconds=random.randint(0, 86399))).isoformat(sep=" "),
        })
    # messy data on purpose
    rows += [dict(r) for r in random.sample(rows, k=max(1, n // 50))]   # ~2% exact duplicates
    for r in random.sample(rows, k=max(1, n // 100)):
        r["amount"] = ""                              # ~1% missing amounts
    random.shuffle(rows)
    return rows


def write_csv(path, rows):
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--days", type=int, default=7)
    p.add_argument("--per-day", type=int, default=500)
    p.add_argument("--seed", type=int, default=42)
    a = p.parse_args()
    random.seed(a.seed)

    customers, merchants = make_customers(300), make_merchants(40)
    write_csv(RAW / "customers.csv", customers)
    write_csv(RAW / "merchants.csv", merchants)

    start = date.today() - timedelta(days=a.days)
    total = 0
    for i in range(a.days):
        day = start + timedelta(days=i)
        rows = make_transactions(day, a.per_day, customers, merchants)
        write_csv(RAW / f"transactions_{day.isoformat()}.csv", rows)
        total += len(rows)
    print(f"Wrote {total} transaction rows over {a.days} days to {RAW}")


if __name__ == "__main__":
    main()
