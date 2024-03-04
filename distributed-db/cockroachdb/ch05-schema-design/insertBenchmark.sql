/* Insert tests */

\set errexit false;

DROP TABLE baseTable;

CREATE TABLE baseTable AS 
with recursive series as (
	select 1 as id union all
	select id + 1 as id
  from series
  where id < 20000
)
SELECT 
  id,
  random() rnumber, 
  md5(random()::STRING) rstring 
FROM series;
  

DROP TABLE seq_keyed;
DROP SEQUENCE seq_seq;
CREATE SEQUENCE seq_seq;

CREATE TABLE seq_keyed (
	pk INT NOT NULL PRIMARY KEY,
	id int,
	rnumber float,
	rstring string
);

SELECT 'integer';

INSERT INTO seq_keyed (pk,id,rnumber,rstring) SELECT id,id,rnumber,rstring FROM basetable;

DROP TABLE seq_keyed;
DROP SEQUENCE seq_seq;
CREATE SEQUENCE seq_seq;

CREATE TABLE seq_keyed  (
	pk INT NOT NULL PRIMARY KEY DEFAULT nextval('seq_seq'),
	id int,
	rnumber float,
	rstring string
);

SELECT 'sequence';

INSERT INTO seq_keyed (id,rnumber,rstring) SELECT * FROM basetable;

DROP TABLE serial_keyed;

CREATE TABLE serial_keyed  (
	pk SERIAL PRIMARY KEY NOT NULL  ,
	id int,
	rnumber float,
	rstring string
);

SELECT 'serial';

INSERT INTO serial_keyed (id,rnumber,rstring) SELECT * FROM basetable;
;

DROP TABLE uuid_keyed;

CREATE TABLE uuid_keyed  (
	pk uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(), 
	id int,
	rnumber float,
	rstring string
);

SELECT 'UUID';

INSERT INTO uuid_keyed (id,rnumber,rstring) SELECT * FROM basetable;

SET experimental_enable_hash_sharded_indexes=on;

DROP TABLE hash_keyed;


-- Hash-sharded primary keys
--   Hash-sharded indexes add a hashed value to the prefix of a primary key. These hash
--   values are unique but nonsequential. Consequently, if the primary key of a table is
--   based on a hash-sharded index, then its values will be distributed evenly across all
--   the ranges in the cluster. The result should be (statistically) a perfect distribution of
--   writes across nodes.
--   At the time of writing, hash-sharded indexes required the experimen
--   tal_enable_hash_sharded_indexes configuration variable be set to on. So to create a
--   hash-sharded primary key, we would use this syntax:
-- SET experimental_enable_hash_sharded_indexes=on;
CREATE TABLE hash_keyed  (
	pk int NOT NULL,
	id int,
	rnumber float,
	rstring STRING,
	PRIMARY KEY (pk) USING HASH WITH BUCKET_COUNT=6
  -- The WITH BUCKET_COUNT clause determines how many “shards” of the index are created. Setting 
  -- the number of buckets to twice the number of nodes in the cluster is a sensible default.
);

SELECT 'hash';

INSERT INTO hash_keyed (pk,id,rnumber,rstring) SELECT id,id,rnumber,rstring FROM basetable;

 

