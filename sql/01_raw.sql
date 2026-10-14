INSTALL httpfs;
LOAD httpfs;

CREATE SCHEMA IF NOT EXISTS raw;

-- Jan–Mar 2024 yellow taxi trips. Change range(1, 4) to load more months.
CREATE OR REPLACE TABLE raw.yellow_trips AS
SELECT *
FROM read_parquet(
    [ 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-'
      || lpad(m::VARCHAR, 2, '0') || '.parquet'
      FOR m IN range(1, 4) ],
    union_by_name = true
);

CREATE OR REPLACE TABLE raw.taxi_zones AS
SELECT * FROM read_csv_auto(
    'https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv'
);