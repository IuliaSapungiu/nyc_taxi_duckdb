CREATE SCHEMA IF NOT EXISTS mart;

-- Date dimension
CREATE OR REPLACE TABLE mart.dim_date AS
SELECT
    strftime(d, '%Y%m%d')::INTEGER AS date_key,
    d::DATE                        AS date,
    year(d)                        AS year,
    month(d)                       AS month,
    monthname(d)                   AS month_name,
    dayofweek(d)                   AS day_of_week,   -- 0 = Sunday
    dayname(d)                     AS day_name,
    dayofweek(d) IN (0, 6)         AS is_weekend
FROM generate_series(DATE '2024-01-01', DATE '2024-03-31', INTERVAL 1 DAY) t(d);

-- Zone dimension
CREATE OR REPLACE TABLE mart.dim_zone AS
SELECT
    LocationID::INTEGER AS zone_id,
    Borough             AS borough,
    Zone                AS zone,
    service_zone
FROM raw.taxi_zones;

-- Payment type dimension
CREATE OR REPLACE TABLE mart.dim_payment_type AS
SELECT * FROM (VALUES
    (0, 'Flex fare'), (1, 'Credit card'), (2, 'Cash'),
    (3, 'No charge'), (4, 'Dispute'),     (5, 'Unknown')
) t(payment_type_id, payment_type);

-- Fact table: one row per trip
CREATE OR REPLACE TABLE mart.fact_trips AS
SELECT
    trip_id,
    strftime(pickup_at, '%Y%m%d')::INTEGER                  AS pickup_date_key,
    hour(pickup_at)                                         AS pickup_hour,
    pickup_zone_id,
    dropoff_zone_id,
    payment_type_id,
    passenger_count,
    trip_distance,
    date_diff('minute', pickup_at, dropoff_at)              AS trip_minutes,
    round(trip_distance / (date_diff('second', pickup_at, dropoff_at) / 3600.0), 1) AS avg_speed_mph,
    fare_amount,
    tip_amount,
    tolls_amount,
    total_amount,
    round(100 * tip_amount / fare_amount, 2)                AS tip_pct
FROM staging.trips;