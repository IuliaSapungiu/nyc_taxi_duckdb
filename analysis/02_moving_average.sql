-- Daily revenue with a 7-day moving average to smooth weekly seasonality.
WITH daily AS (
    SELECT d.date, d.day_name, sum(f.total_amount) AS revenue
    FROM mart.fact_trips f
    JOIN mart.dim_date d ON f.pickup_date_key = d.date_key
    GROUP BY d.date, d.day_name
)
SELECT
    date,
    day_name,
    round(revenue)                                                   AS revenue,
    round(avg(revenue) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)) AS moving_avg_7d
FROM daily
ORDER BY date;