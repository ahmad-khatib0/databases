DROP TABLE arrayTable;

CREATE TABLE arrayTable (arrayColumn STRING[]);
CREATE TABLE c (d INT ARRAY);

-- The ARRAY function allows us to insert multiple items into the ARRAY:
INSERT INTO arrayTable VALUES (ARRAY['sky', 'road', 'car']);
SELECT arrayColumn[2] FROM arrayTable;
 
 
SELECT * FROM arrayTable WHERE arrayColumn @>ARRAY['road'];

UPDATE  arrayTable
   SET arrayColumn=array_append(arrayColumn,'cat')
WHERE arrayColumn @>ARRAY['car']
RETURNING arrayColumn ;
  
 
 
UPDATE  arrayTable SET arrayColumn = array_remove ( arrayColumn, 'car')
WHERE arrayColumn @> ARRAY['car'] RETURNING arrayColumn;
 
-- The Information Schema
-- The information schema is a special schema in each database that contains metadata
-- about the other objects in the database—it is named INFORMATION_SCHEMA in Cock‐
-- roachDB. You can use the information schema to discover the names and types of
-- objects in the database. For instance, you can use the information schema to list all
-- the objects in the information_schema schema:
SELECT * FROM information_schema."tables" 
WHERE table_schema='information_schema';

SELECT table_catalog, table_schema, table_name, table_type  
FROM information_schema."tables";

-- use information_schema to show the columns in a table: 
SELECT column_name,data_type, is_nullable,column_default 
FROM information_schema.COLUMNS WHERE TABLE_NAME='customers';

-- The unnest function transforms an array into a tabular result—one row for
-- each element of the array. This can be used to “join” the contents of an 
-- array with data held in relational form elsewhere in the database. 
SELECT unnest(arrayColumn)
FROM (
  (("queries", "arrays", startref="qarys"))
) arrayTable;

-- unnest
-- ----------
-- sky
-- road
-- cat


