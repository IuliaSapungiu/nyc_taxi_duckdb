import pathlib
import sys
import duckdb

con = duckdb.connect("taxi.duckdb")

for f in ["01_raw", "02_staging", "03_star_schema"]:
    print(f"▶ running sql/{f}.sql")
    con.execute(pathlib.Path(f"sql/{f}.sql").read_text())

print("▶ running data quality checks")
rows = con.execute(pathlib.Path("sql/04_checks.sql").read_text()).fetchall()
failed = False
for name, violations in rows:
    status = "OK  " if violations == 0 else "FAIL"
    print(f"  [{status}] {name}: {violations}")
    failed |= violations > 0

sys.exit(1 if failed else 0)