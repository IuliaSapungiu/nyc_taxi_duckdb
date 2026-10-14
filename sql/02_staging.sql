CREATE SCHEMA IF NOT EXISTS staging;

CREATE OR REPLACE TABLE staging.trips AS
SELECT
    row_number() OVER ()                        AS trip_id,
    tpep_pickup_datetime                        AS pickup_at,
    tpep_dropoff_datetime                       AS dropoff_at,
    passenger_count::INTEGER                    AS passenger_count,
    trip_distance,
    PULocationID                                AS pickup_zone_id,
    DOLocationID                                AS dropoff_zone_id,
    coalesce(payment_type, 5)::INTEGER          AS payment_type_id,
    fare_amount,
    tip_amount,
    tolls_amount,
    total_amount
FROM raw.yellow_trips
WHERE tpep_pickup_datetime >= TIMESTAMP '2024-01-01'
  AND tpep_pickup_datetime <  TIMESTAMP '2024-04-01'
  AND tpep_dropoff_datetime > tpep_pickup_datetime
  AND date_diff('minute', tpep_pickup_datetime, tpep_dropoff_datetime) < 360
  AND trip_distance > 0
  AND fare_amount > 0
  AND total_amount > 0;