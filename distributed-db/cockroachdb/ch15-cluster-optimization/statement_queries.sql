/* 
   Some queries against the crdb_internal views
*/

-- Another way to get currently executing queries is by querying 
-- the system. crdb_internal.cluster_queries table:
SELECT 
  node_id, 
  current_timestamp AT time ZONE `UTC` - START run_time, 
  user_name, 
  QUERY, 
  phase
FROM SYSTEM.crdb_internal.cluster_queries
ORDER BY START LIMIT 10;

-- You can use the crdb_internal.node_statement_statistics table to look at state‐
-- ments executed on a particular node. This table lets you hunt for statements matching
-- various criteria, including text matches for the SQL:
SELECT 
  KEY, 
  count, 
  service_lat_avg, 
  count::float * service_lat_avg sum_service
FROM crdb_internal.node_statement_statistics
ORDER BY count::float * service_lat_avg DESC LIMIT 10

WITH txn_statements AS (
  SELECT 
    KEY, 
    unnest(statement_ids) statement_id,
    max_retries,
    contention_time_avg 
  FROM crdb_internal.node_transaction_statistics
)

SELECT * FROM txn_statements ts 
JOIN crdb_internal.node_queries q ON ( ts.statement_id=q.QUERY_id) 
ORDER BY max_retries desc,contention_time_avg DESC 

SELECT * from crdb_internal.node_queries WHERE query_id='1288264448111598659'

-- The amount of memory needed in max-sql-memory will depend largely on the complexity of the 
-- SQL your system must accommodate. You can see the memory requirements for individual SQL 
-- statements using EXPLAIN ANALYZE:
-- movr> 
EXPLAIN ANALYZE 
  SELECT v.TYPE,sum(revenue) FROM rides r
  JOIN vehicles v ON (v.city=r.city AND r.vehicle_id=v.id )
  GROUP BY v.type ORDER BY 2 desc;
