SHOW data_directory;   -- where this db is stored

select oid, datname from pg_database; 
-- show which id each db represent in the base folder (where pg stored data)

select * from pg_class ; 
-- see what objects each file represent for a particular db (objects are tables, indexis, pages, sequences...) 

create  index  users_username_idx on users(username); 

SELECT pg_size_pretty(pg_relation_size("users")); 
-- the size of users table, also can be used to see the size of an index

SELECT relname, relkind FROM pg_class where relkind = "i";
-- list all index in the db

SELECT * FROM pg_stats where tablename  = "users";

-- list all reserved and unreserved keywords 
SELECT * FROM pg_get_keywords();

-- SET the searching path schema piriority
SET search_path TO test, public; 

-- set the searching path schema to the default 
SET search_path TO "$user", public; 

-- SHOW what pg will select if there are more than one schema
SHOW search_path; 

-- List all index names, column names and its table name of the pg database
SELECT 
  i.relname as indname, 
  i.relowner as indowner, 
  idx.indrelid :: regclass, 
  am.amname as indam, 
  idx.indkey, 
  ARRAY(
    SELECT 
      pg_get_indexdef(idx.indexrelid, k + 1, true) 
    FROM 
      generate_subscripts(idx.indkey, 1) as k 
    ORDER BY 
      k
  ) as indkey_names, 
  idx.indexprs IS NOT NULL as indexprs, 
  idx.indpred IS NOT NULL as indpred 
FROM 
  pg_index as idx 
  JOIN pg_class as i ON i.oid = idx.indexrelid 
  JOIN pg_am as am ON i.relam = am.oid;
