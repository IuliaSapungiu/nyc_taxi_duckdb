-- Days where revenue dropped >15% vs the same weekday a week earlier
-- (weather, holidays, anomalies worth investigating).
WITH daily AS (
    SELECT d.date, d.day_name, sum(f.total_amount) AS revenue
    FROM mart.fact_trips f
    JOIN mart.dim_date d ON f.pickup_date_key = d.date_key
    GROUP BY d.date, d.day_name
),
compared AS (
    SELECT
        date, day_name, revenue,
        lag(revenue, 7) OVER (ORDER BY date) AS revenue_last_week,
        round(100 * (revenue / lag(revenue, 7) OVER (ORDER BY date) - 1), 1) AS pct_change
    FROM daily
)
SELECT date, day_name, round(revenue) AS revenue, round(revenue_last_week) AS revenue_last_week, pct_change
FROM compared
WHERE pct_change < -15
ORDER BY pct_change;