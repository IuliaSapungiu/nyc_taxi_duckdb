SELECT 'fact has rows' AS check_name,
       CASE WHEN count(*) > 0 THEN 0 ELSE 1 END AS violations
FROM mart.fact_trips
UNION ALL
SELECT 'trip_id is unique', count(*) - count(DISTINCT trip_id)
FROM mart.fact_trips
UNION ALL
SELECT 'pickup zone exists in dim_zone', count(*)
FROM mart.fact_trips f
LEFT JOIN mart.dim_zone z ON f.pickup_zone_id = z.zone_id
WHERE z.zone_id IS NULL
UNION ALL
SELECT 'dropoff zone exists in dim_zone', count(*)
FROM mart.fact_trips f
LEFT JOIN mart.dim_zone z ON f.dropoff_zone_id = z.zone_id
WHERE z.zone_id IS NULL
UNION ALL
SELECT 'pickup date exists in dim_date', count(*)
FROM mart.fact_trips f
LEFT JOIN mart.dim_date d ON f.pickup_date_key = d.date_key
WHERE d.date_key IS NULL
UNION ALL
SELECT 'payment type exists in dim_payment_type', count(*)
FROM mart.fact_trips f
LEFT JOIN mart.dim_payment_type p USING (payment_type_id)
WHERE p.payment_type_id IS NULL
UNION ALL
SELECT 'no negative amounts', count(*)
FROM mart.fact_trips
WHERE total_amount < 0 OR fare_amount < 0;