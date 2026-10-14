-- Top 3 busiest pickup zones within each borough.
SELECT z.borough, z.zone, count(*) AS trips
FROM mart.fact_trips f
JOIN mart.dim_zone z ON f.pickup_zone_id = z.zone_id
WHERE z.borough NOT IN ('Unknown', 'N/A')
GROUP BY z.borough, z.zone
QUALIFY row_number() OVER (PARTITION BY z.borough ORDER BY count(*) DESC) <= 3
ORDER BY z.borough, trips DESC;