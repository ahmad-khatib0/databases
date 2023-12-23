DROP TABLE orderdetails;
 

CREATE TABLE orderdetails AS SELECT * FROM adventureworks.sales.salesorderdetail s;

EXPLAIN ANALYZE SELECT * FROM orderdetails ORDER BY modifieddate;

EXPLAIN ANALYZE SELECT * FROM orderdetails ORDER BY modifieddate  LIMIT 10;

CREATE INDEX orderdetails_moddate_ix ON orderdetails(modifieddate) ;

EXPLAIN ANALYZE SELECT * FROM orderdetails ORDER BY modifieddate;

EXPLAIN ANALYZE SELECT * FROM orderdetails@orderdetails_moddate_ix ORDER BY modifieddate;

EXPLAIN ANALYZE SELECT * FROM orderdetails ORDER BY modifieddate LIMIT 10;

SELECT * FROM orderdetails ORDER BY modifieddate;
 
SET experimental_enable_hash_sharded_indexes=on;

-- If you have indexed columns where the value is constantly increasing 
-- (timestamps are a good example) and you want to avoid such an insert hotspot, 
-- then you should consider hash-sharding the index. 
CREATE INDEX orderdetails_hash_ix ON orderdetails(modifieddate) 
USING HASH WITH BUCKET_COUNT=6;

DROP INDEX orderdetails_moddate_ix;

-- Note that while CockroachDB might not optimize a sort with a hash-sharded index,
-- it still might provide good enough performance for a “top 10” type of query
EXPLAIN ANALYZE SELECT * FROM orderdetails@orderdetails_hash_ix  ORDER BY modifieddate LIMIT 10;


