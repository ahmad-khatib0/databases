SELECT 
  cast(r.start_time AS date) AS ride_date, u.city, SUM(r.revenue)
FROM rides r
JOIN users u ON (u.id=r.rider_id)
GROUP BY 1,2

-- Summary Tables
-- A summary table typically contains aggregated information that is expensive to com‐
-- pute on the fly. For instance, in the MovR application, we might have a dashboard
-- that shows revenue trends by city based on the following query:
SELECT 
    CAST(r.start_time AS date) AS ride_date, 
    u.city, 
    SUM(r.revenue) 
FROM rides r
JOIN users u ON (u.id = r.rider_id) GROUP BY 1, 2;
-- Because revenue for previous days rarely changes, it’s wasteful to continually reissue
-- this expensive query every time the dashboard requests it. Instead, we create a
-- summary table from this data and reload the data at regular intervals (perhaps once an hour):

CREATE MATERIALIZED VIEW ride_revenue_by_date_city AS 
  SELECT cast(r.start_time AS date) AS ride_date, u.city, SUM(r.revenue)
  FROM rides r
  JOIN users u ON (u.id=r.rider_id)
  GROUP BY 1,2;
 
SELECT COUNT(*) FROM ride_revenue_by_date_city
COMMIT;

REFRESH MATERIALIZED VIEW ride_revenue_by_date_city;


