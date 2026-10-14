import pathlib
import duckdb

con = duckdb.connect("taxi.duckdb", read_only=True)
pathlib.Path("results").mkdir(exist_ok=True)

for f in sorted(pathlib.Path("analysis").glob("*.sql")):
    print(f"\n=== {f.name} ===")
    rel = con.sql(f.read_text())
    rel.show(max_rows=15)
    rel.write_csv(f"results/{f.stem}.csv")