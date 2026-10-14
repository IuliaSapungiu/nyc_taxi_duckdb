import os
import time
import duckdb

con = duckdb.connect("taxi.duckdb", read_only=True)

# 1. Export the fact table in two formats
con.execute("COPY mart.fact_trips TO 'fact_trips.parquet' (FORMAT parquet)")
con.execute("COPY mart.fact_trips TO 'fact_trips.csv' (FORMAT csv, HEADER)")

# 2. Same query against three sources
QUERY = "SELECT pickup_hour, count(*) AS trips, avg(total_amount) AS avg_total FROM {src} GROUP BY 1"
sources = {
    "DuckDB table": "mart.fact_trips",
    "Parquet file": "read_parquet('fact_trips.parquet')",
    "CSV file": "read_csv_auto('fact_trips.csv')",
}

def best_time(src, runs=3):
    times = []
    for _ in range(runs):
        start = time.perf_counter()
        con.execute(QUERY.format(src=src)).fetchall()
        times.append(time.perf_counter() - start)
    return min(times)

sizes = {
    "Parquet file": os.path.getsize("fact_trips.parquet") / 1e6,
    "CSV file": os.path.getsize("fact_trips.csv") / 1e6,
}

# 3. Print a markdown table you can paste into the README
print("| Source | Size (MB) | Query time (s) |")
print("|---|---|---|")
for name, src in sources.items():
    size = f"{sizes[name]:.0f}" if name in sizes else "-"
    print(f"| {name} | {size} | {best_time(src):.3f} |")