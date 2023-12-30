\set prompt1=%/>

USE movr;

DROP INDEX rides_address_times_ix;
DROP INDEX rides_address_ix;

EXPLAIN SELECT start_time, end_time FROM rides
WHERE 
  city = 'amsterdam'
  AND start_address = '67104 Farrell Inlet'
  AND end_address = '57998 Harvey Burg Suite 87';

EXPLAIN ANALYSE SELECT start_time, end_time FROM rides
WHERE 
  city = 'amsterdam'
  AND start_address = '67104 Farrell Inlet'
  AND end_address = '57998 Harvey Burg Suite 87';

CREATE INDEX rides_address_ix ON rides(city,start_address,end_address);

EXPLAIN SELECT start_time, end_time FROM rides
WHERE 
  city = 'amsterdam'
  AND start_address = '67104 Farrell Inlet'
  AND end_address = '57998 Harvey Burg Suite 87';

EXPLAIN ANALYZE SELECT start_time, end_time FROM rides
WHERE 
  city = 'amsterdam'
  AND start_address = '67104 Farrell Inlet'
  AND end_address = '57998 Harvey Burg Suite 87';


CREATE INDEX rides_address_times_ix ON rides
(city,start_address,end_address ) STORING (start_time,end_time);

-- we can force the use of a specific index:
EXPLAIN SELECT start_time, end_time FROM rides@rides_address_times_ix
WHERE 
  city = 'amsterdam'
  AND start_address = '67104 Farrell Inlet'
  AND end_address = '57998 Harvey Burg Suite 87';

EXPLAIN ANALYZE SELECT start_time, end_time FROM rides
WHERE 
  city = 'amsterdam'
  AND start_address = '67104 Farrell Inlet'
  AND end_address = '57998 Harvey Burg Suite 87';

EXPLAIN SELECT start_time, end_time FROM rides
WHERE city = 'amsterdam' AND start_address = '67104 Farrell Inlet';

-- Index hints
-- If we want to force a particular index access path for a table access, we can do
-- so by specifying the index name in the FROM clause. For instance, if we specify
-- rides@primary, then we’ll use the base table 
EXPLAIN (OPT) SELECT start_time, end_time FROM rides@primary
WHERE 
  city = 'amsterdam' 
  AND end_address = '57998 Harvey Burg Suite 87';

EXPLAIN SELECT start_time, end_time FROM rides  
WHERE end_address = '57998 Harvey Burg Suite 87';

DROP INDEX rides_address_times_ix;
DROP INDEX rides_address_ix;

CREATE INDEX user_address_ix ON USERS(address) STORING (name);

EXPLAIN SELECT name FROM USERS WHERE address='20069 Tara Cove';

EXPLAIN SELECT name FROM USERS WHERE address LIKE '% Tara Cove';

EXPLAIN SELECT name FROM USERS WHERE upper(address)=UPPER('20069 Tara Cove');

EXPLAIN SELECT name FROM USERS WHERE address ILIKE '20069 Tara Cove';


