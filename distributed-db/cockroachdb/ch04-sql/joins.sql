SELECT COUNT(*) 
  FROM vehicles v 
  JOIN rides r ON (r.vehicle_id=v.id);
    
-- The OUTER JOIN allows rows to be included even if they have no match in the other
-- table. Rows that are not found in the OUTER JOIN table are represented by NULL values.
SELECT v.id,v.ext,r.start_time r.start_address 
  FROM vehicles v 
  LEFT OUTER JOIN rides r ON (r.vehicle_id=v.id);
    
SELECT u.name , upc.code FROM USERS u 
  JOIN user_promo_codes upc ON (u.id=upc.user_id);
   
SELECT u.name , upc.code FROM USERS u 
  LEFT OUTER JOIN user_promo_codes upc ON (u.id=upc.user_id);   
   
SELECT DISTINCT u.name , upc.code FROM user_promo_codes upc 
  RIGHT OUTER JOIN USERS u ON (u.id=upc.user_id); 
   
 
SELECT city, user_id, code, "timestamp", usage_count
FROM public.user_promo_codes;

DROP TABLE employees;

CREATE TABLE employees AS 
 SELECT * FROM USERS LIMIT 10;


-- If the JOIN is on an identically named column in both tables, then the USING clause provides 
-- a handy shortcut, Here we join users and user_ride_counts using the common name column
SELECT u.city, SUM(urc.rides), AVG(urc.rides), max(urc.rides) FROM users u 
  JOIN user_ride_counts urc USING (name) GROUP BY u.city;

SELECT COUNT(*) FROM employees;

-- It is often required to select all rows from a table that do not have a matching
-- row in some other result set. This is called an anti-join, and while there is no SQL
-- syntax for this concept, it is typically implemented using a subquery and the IN or
-- EXISTS clause. The following example illustrates an anti-join using the EXISTS and IN 
-- operators. Each example selects users who are not also employees:
SELECT * FROM users 
  WHERE id NOT IN (
  SELECT id FROM employees
);
       
EXPLAIN SELECT * FROM users u
WHERE NOT EXISTS (
  SELECT id FROM employees e WHERE e.id=u.id
);
          
DROP TABLE customers;

CREATE TABLE customers AS SELECT * FROM USERS WHERE city <> 'boston';

SELECT * FROM users u
WHERE NOT EXISTS (
  SELECT id FROM employees e WHERE e.id=u.id
);
       
SELECT name, address FROM customers MINUS;

SELECT name,address FROM employees;

-- INTERSECT returns those rows that are in both result sets. 
-- This query returns customers who are also employees:
SELECT name, address FROM customers
 INTERSECT 
SELECT name, address FROM employees;
  
-- EXCEPT returns rows in the first result set that are not present in 
-- the second. This query returns customers who are not also employees:
SELECT name, address FROM customers
 EXCEPT 
SELECT name,address FROM employees;
  

-- CROSS JOIN indicates that every row in the left table should be joined to every row in
-- the right table. Usually, this is a recipe for disaster unless one of the tables has only
-- one row or is a laterally correlated subquery 
-- Lateral Subquery: 
-- When a subquery is used in a join, the LATERAL keyword indicates that the subquery
-- may access columns generated in preceding FROM table expressions. For instance, in
-- the following query, the LATERAL keyword allows the subquery to access columns
-- from the users table: 
SELECT name, address, start_time FROM USERS
CROSS JOIN LATERAL (
    SELECT * FROM rides 
    WHERE rides.start_address = users.address 
  ) r;
                  
WITH riderRevenue AS (
  SELECT u.id, SUM(r.revenue) AS sumRevenue FROM rides r 
  JOIN "users" u ON (r.rider_id = u.id) GROUP BY u.id 
);

SELECT * FROM "users" u2 JOIN riderRevenue rr USING (id)
ORDER BY sumrevenue DESC;
 
SELECT city,start_time, (end_time-start_time) duration FROM rides r
ORDER BY city,(end_time-start_time) DESC;


-- Subqueries may also be used in the FROM clause wherever a table or view definition could appear. 
-- This query generates a result that compares each ride with the average ride duration for the city:
SELECT id, city,(end_time-start_time) ride_duration, avg_ride_duration FROM rides 
JOIN (
   SELECT city, AVG(end_time-start_time) avg_ride_duration FROM rides
   GROUP BY city
  )
USING(city) ;
  

-- You can also order by an index. In the following example, rows will be ordered by
-- city and start_time, since those are the columns specified in the index:
CREATE INDEX rides_start_time ON rides (city ,start_time);
USE movr 
SELECT city, start_time, (end_time - start_time) duration FROM rides
ORDER BY INDEX rides@rides_start_time;
  
CREATE TABLE ab(
  a INT, 
  b INT, 
  INDEX b_idx (b DESC, a ASC)
);
 
CREATE TABLE kv(
  k INT PRIMARY KEY, 
  v INT, 
  INDEX v_idx(v)
);

SELECT k, v FROM kv ORDER BY INDEX kv@v_idx;


-- Window Functions: 
-- functions that operate over a subset—a “window” of the complete set of the results..
-- PARTITION BY and ORDER BY create a sort of “virtual table” that the function works
-- with. For instance, this query lists the top 10 rides in terms of revenue, with the
-- percentage of the total revenue and city revenue displayed:
SELECT 
   city, 
   r.start_time,
   revenue,
   revenue*100/SUM(revenue) OVER () AS pct_total_revenue,
   revenue*100/SUM(revenue) OVER (PARTITION BY city) AS pct_city_revenue
FROM rides r
ORDER BY 5 DESC LIMIT 10;

-- There are some aggregation functions that are specific to windowing functions. RANK() ranks 
-- the existing row within the relevant window, and DENSE_RANK() does the same while allowing 
-- no “missing” ranks. LEAD and LAG provide access to functions in adjacent partitions.
-- For instance, this query returns the top 10 rides, with each ride’s overall rank and
-- rank within the city displayed:
SELECT 
  city, 
  r.start_time ,
  revenue,
  RANK() OVER (ORDER BY revenue DESC) AS total_revenue_rank,
  RANK() OVER (PARTITION BY city ORDER BY revenue DESC) AS city_revenue_rank
FROM rides r
ORDER BY revenue DESC LIMIT 10;

