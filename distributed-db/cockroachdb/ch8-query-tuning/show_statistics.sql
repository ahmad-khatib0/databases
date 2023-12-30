
USE movr;
\set display_format=table 

-- look at the statistics collected for a specific table:
SHOW STATISTICS FOR table rides;

-- see the most recent statistics
WITH rides_statistics AS (
  SELECT * FROM [SHOW STATISTICS FOR TABLE rides]
)
SELECT column_names,row_count,distinct_count,null_count FROM rides_statistics r
WHERE created = (
	SELECT max(created) FROM rides_statistics WHERE column_names=r.column_names
);

 
SELECT * FROM [SHOW JOBS] 
WHERE job_type LIKE '%CREATE STATS%' 
ORDER BY finished DESC LIMIT 1;

SELECT distinct job_type FROM [SHOW jobs]

-- You can also create statistics for a nominated set of columns
CREATE STATISTICS city_routes ON start_address, end_address FROM movr.public.rides;
-- So This gives the optimizer an idea of the cardinality for that combination of columns.
-- We might do this when two columns are related in some way that the optimizer
-- doesn’t know about. In this case, we know intuitively that each address resides within
-- a single city. Unless we collect the statistics, the optimizer will assume that they are
-- independent and consequently overestimate the number of distinct values.

CREATE STATISTICS ON * FROM rides;

\SET display_format=records;

SELECT * FROM [SHOW CLUSTER SETTINGS]  WHERE variable LIKE '%sql%';

SELECT variable, description FROM [SHOW CLUSTER SETTINGS] WHERE description LIKE '%join%';

-- to reduce overhead if we do expansive sorts
\SET cluster setting sql.distsql.temp_storage.workmem='500 MiB'; 


-- ╒═══════════════════════════════════════════════════════════════════════════════════════════╕
--    There are a relatively limited number of situations in which changing statistics would 
--    be warranted. The automatic statistics collection triggers (on average) when 20% of a  
--    table has changed. In some cases, this is insufficient when a specific column is subject
--    to frequent changes. For example, if you have a timestamp column where the values      
--    are increasing over time, the histogram will show no recent values most of the time,   
--    which can make the optimizer choose an index on that column even when it’s a bad       
--    idea. Another example would be a “status” column that showed whether some task         
--    was complete or in progress. Depending on when the statistics were collected, the      
--    histogram might show no in-progress tasks.                                             
-- └───────────────────────────────────────────────────────────────────────────────────────────┘


