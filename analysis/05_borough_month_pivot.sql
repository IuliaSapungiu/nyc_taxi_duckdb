-- Revenue by borough (rows) and month (columns).
PIVOT (
    SELECT z.borough, d.month_name, f.total_amount
    FROM mart.fact_trips f
    JOIN mart.dim_zone z ON f.pickup_zone_id = z.zone_id
    JOIN mart.dim_date d ON f.pickup_date_key = d.date_key
)
ON month_name
USING round(sum(total_amount))
GROUP BY borough
ORDER BY borough;