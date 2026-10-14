-- Trips per weekday and hour (feed this into a heatmap chart).
SELECT
    d.day_name,
    f.pickup_hour,
    count(*)                                AS trips,
    round(avg(f.tip_pct) FILTER (WHERE f.payment_type_id = 1), 1) AS avg_tip_pct_card
FROM mart.fact_trips f
JOIN mart.dim_date d ON f.pickup_date_key = d.date_key
GROUP BY d.day_name, d.day_of_week, f.pickup_hour
ORDER BY d.day_of_week, f.pickup_hour;