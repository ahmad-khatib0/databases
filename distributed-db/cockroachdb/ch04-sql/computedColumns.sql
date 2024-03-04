DROP TABLE people;

-- Computed Columns: 
--  CockroachDB allows tables to include computed columns that 
--  in some other databases would require a view definition:
-- column_name AS expression [STORED|VIRTUAL]
-- A VIRTUAL computed column is evaluated whenever it is referenced. A STORED expression is 
-- stored in the database when created and need not always be recomputed. For instance, this 
-- table definition has the firstName and lastName concatenated into a fullName column:

CREATE TABLE people ( 
  id INT PRIMARY KEY, 
  firstName VARCHAR NOT NULL, 
  lastName VARCHAR NOT NULL, 
  dateOfBirth timestamp NOT NULL, 
  phoneNumber VARCHAR NOT NULL, 
  fullName STRING AS (CONCAT(firstName, ' ', lastName) ) STORED, 
  age int AS (now()-dateOfBirth) VIRTUAL 
);

-- Computed columns cannot be context-dependent. That is, the computed value must
-- not change over time or be otherwise nondeterministic. For instance, the computed
-- column in the following example would not work since the age column would be
-- static rather than recalculated every time. While it might be nice to stop aging in real
-- life, we probably want the age column to increase as time goes on:
 -- ╒══════════════════════════════════════════╕
 --    age int AS (now()-dateOfBirth) STORED 
 -- └──────────────────────────────────────────┘

CREATE TABLE people ( 
  id INT PRIMARY KEY , 
  firstName VARCHAR NOT NULL , 
  lastName VARCHAR NOT NULL , 
  dateOfBirth timestamp NOT NULL , 
  phoneNumber VARCHAR  NULL , 
  fullName STRING AS (CONCAT(firstName, ' ', lastName) ) STORED 
);

INSERT INTO people (id, firstName, lastName, dateOfBirth)
VALUES(1, 'Guy', 'Harrison', '21-JUN-1960');

SELECT * FROM people;

UPDATE people SET firstname='Fred';

SELECT * FROM people;
USE movr;
SELECT CAST(revenue AS int) FROM rides;

CREATE INDEX people_namedob_ix ON people (lastName, firstName, dateOfBirth);

DROP INDEX people_namedob_ix;

CREATE UNIQUE INDEX people_namedob_ix ON people (lastName, firstName, dateOfBirth);

DROP INDEX people_namedob_ix;

-- The STORING clause allows us to store additional data in the index, which can allow
-- us to satisfy queries using the index alone. For instance, this index can satisfy queries
-- that retrieve phone numbers for a given name and date of birth:
CREATE UNIQUE INDEX people_namedob_ix ON people (
   lastName, firstName, dateOfBirth
) STORING (phoneNumber);

INSERT INTO people (id, firstName, lastName, dateOfBirth)
VALUES(1, 'Guy', 'Harrison', '21-JUN-1960');

SELECT * FROM people;

SELECT NOW() - dateOfBirth FROM people;

DROP TABLE people;

CREATE TABLE people ( 
  id UUID NOT NULL DEFAULT gen_random_uuid(), 
  firstName VARCHAR NOT NULL, 
  lastName VARCHAR NOT NULL,
  dateOfBirth DATE NOT NULL
);

INSERT INTO people (firstName, lastName, dateOfBirth) VALUES('Guy', 'Harrison', '21-JUN-1960');

CREATE TABLE peopleStagingData AS SELECT * FROM people;

INSERT INTO people (firstName, lastName, dateOfBirth)
SELECT firstName, lastName, dateOfBirth FROM peopleStagingData;
 
DELETE FROM people WHERE firstName='Guy' AND lastName='Harrison';
  
SELECT * FROM people;

DROP TABLE people;

CREATE TABLE people( 
   id UUID NOT NULL DEFAULT gen_random_uuid(), 
   personData JSONB 
);

INSERT INTO people (personData) VALUES('{
    "firstName":"Guy",
    "lastName":"Harrison",
    "dob":"21-Jun-1960",
    "phone":"0419533988",
    "photo":"eyJhbGciOiJIUzI1NiIsI..."
}');

SELECT personData->'phone' FROM people
WHERE personData->>'phone' = '"0419533988"';

-- An inverted index can be used to index the elements within an 
-- array or the attributes within a JSON document.
CREATE INVERTED INDEX people_inv_idx ON people(personData);

SELECT * FROM people WHERE personData @> '{"phone":"0419533988"}';

EXPLAIN SELECT * FROM people
WHERE personData @> '{"phone":"0419533988"}';

 -- ╒══════════════════════════════════════════════════════════════════════════════════════════════╕
 --    Because inverted indexes index every attribute in the JSON document, not                  
 --    just those that you want to search on. SO This potentially results in a very large index. 
 --    Therefore, you might find it more useful to create a calculated column on the JSON        
 --    attribute and then index on that computed column:                                         
 -- └──────────────────────────────────────────────────────────────────────────────────────────────┘
ALTER TABLE people ADD phone STRING AS (personData->>'phone') VIRTUAL;
CREATE INDEX people_phone_idx ON people(phone);

EXPLAIN SELECT id FROM people WHERE phone = '0419533988';

DROP TABLE people;

-- Hash-sharded indexes
-- If you’re working with a table that must be indexed on sequential keys, you should
-- use hash-sharded indexes. Hash-sharded indexes distribute sequential traffic uniformly 
-- across ranges, eliminating single-range hotspots and improving write performance 
-- on sequentially keyed indexes at a small cost to read performance:
CREATE TABLE people ( 
  id INT PRIMARY KEY, 
  firstName VARCHAR NOT NULL, 
  lastName VARCHAR NOT NULL, 
  dateOfBirth timestamp NOT NULL, 
  phoneNumber VARCHAR NOT NULL,
  serialNo SERIAL ,
  INDEX serialNo_idx (serialNo) USING HASH WITH BUCKET_COUNT=4
);
  
/* ORDERING */
USE movr 
EXPLAIN SELECT id, city, "name", address, credit_card
FROM movr.public."users" ORDER BY INDEX users@city_idx

CREATE INDEX city_idx ON "users" (city);

-- Note that while CREATE TABLE AS SELECT can be used to create summary tables and
-- the like, CREATE MATERIALIZED VIEW offers a more functional alternative.
CREATE TABLE user_ride_counts AS
SELECT u.name, COUNT(u.name) AS rides 
FROM "users" AS u JOIN "rides" AS r ON (u.id=r.rider_id)
GROUP BY u.name
 
/* Imprt */
IMPORT TABLE customers (
  id UUID PRIMARY KEY,
  name TEXT,
  INDEX name_idx (name)
)

CSV DATA (
  's3://acme-co/customers.csv?AWS_ACCESS_KEY_ID=[placeholder]&AWS_SECRET_ACCESS_KEY=[placeholder]&AWS_SESSION_TOKEN=[placeholder]'
);

IMPORT TABLE customers (
  id INT PRIMARY KEY,
  name STRING,
  INDEX name_idx (name)
)

CSV DATA ('nodelocal://1/customers.csv');

USE movr 
  
SELECT COUNT(*) FROM rides 
WHERE (end_time-start_time) = (
  SELECT MAX(end_time-start_time) FROM rides 
);
 
 
SELECT 
  id, 
  city, 
  (end_time - start_time) ride_duration, 
  avg_ride_duration 
FROM rides
JOIN (
      SELECT city, AVG(end_time-start_time) avg_ride_duration FROM rides
      GROUP BY city
    )
USING(city) ;
    
-- In CockroachDB, data types may be cast—or converted—by appending the data type
-- to an expression using “::”. For instance:
SELECT revenue::int FROM rides;



-- In this example, the primary key of user_promo_codes is (city, user_id, code). if
-- a user already has an entry for that combination in the table, then that row is updated
-- with a user_count of 0. otherwise, a new row with those values is created.
UPSERT INTO user_promo_codes ( user_id,city,code,timestamp,usage_count)
SELECT id, city, 'NewPromo', now(), 0 FROM "users";


-- The time can be specified as an offset, or an absolute timestamp, 
SELECT * FROM rides r AS OF SYSTEM TIME '-1d';  -- or
SELECT * FROM rides r AS OF SYSTEM TIME '2021-5-22 18:02:52.0+00:00';

-- The time specified cannot be older in seconds than the replication zone configuration
-- parameter ttlseconds, which controls the maximum age of MVCC snapshots.
-- It is also possible to specify bounded stale reads using the with_max_staleness argument:
-- Bounded stale reads can be used to optimize performance in distributed deployments
-- by allowing CockroachDB to satisfy the read from local replicas that may contain
-- slightly stale data.
SELECT * FROM rides r AS OF SYSTEM TIME with_max_staleness('10s')
WHERE city = 'amsterdam' AND id = 'aaaae297-396d-4800-8000-0000000208d6';




