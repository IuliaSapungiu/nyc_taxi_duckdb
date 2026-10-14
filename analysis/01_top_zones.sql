-- Which pickup zones generate the most revenue, and what share of the total?
SELECT
    z.zone,
    z.borough,
    count(*)                                   AS trips,
    round(sum(f.total_amount))                 AS revenue,
    round(100 * sum(f.total_amount) / sum(sum(f.total_amount)) OVER (), 2) AS pct_of_total,
    rank() OVER (ORDER BY sum(f.total_amount) DESC) AS revenue_rank
FROM mart.fact_trips f
JOIN mart.dim_zone z ON f.pickup_zone_id = z.zone_id
GROUP BY z.zone, z.borough
ORDER BY revenue_rank
LIMIT 10;