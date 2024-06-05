
CREATE TABLE articles( 
  id int PRIMARY KEY, 
  description text NOT NULL, 
  quantity int NOT NULL
);


ALTER TABLE articles
  ADD COLUMN feet float,
  ADD COLUMN inches float,
  ADD COLUMN meters float,
  ADD COLUMN pints float,
  ADD COLUMN liters float,
  ADD COLUMN gallons float,
  ADD COLUMN kg float,
  ADD COLUMN ounces float,
  ADD COLUMN pounds float,
ALTER COLUMN quantity DROP NOT NULL;

UPDATE articles SET 
  description = 'Dates', kg = quantity, 
  quantity = null
WHERE id = 4;


-- We then insert a few new articles, demonstrating the use of the new units:
INSERT INTO articles (id, liters, description) VALUES (6, 15, 'Fresh orange juice');
INSERT INTO articles (id, meters, description) VALUES (7, 4.15, 'Green celery sticks');
INSERT INTO articles (id, pounds, description) VALUES (8, 19, 'Hazelnuts');

-- With all the new columns, our table has become quite sparse:
SELECT * FROM articles ORDER BY id;

-- Now, we can move the sparse columns to a single JSON column: 
-- we will create a new articles2 table so that we can retain the original and compare it to the new one:
CREATE TABLE articles2( 
  id int PRIMARY KEY, 
  description text NOT NULL, 
  j jsonb
);

-- We populate articles2 with three SQL statements:
INSERT INTO articles2
  SELECT id, description, to_jsonb(articles)
FROM articles;

UPDATE articles2 SET j['id'] = null, j['description'] = null;

UPDATE articles2 SET j = jsonb_strip_nulls(j);

-- The first statement copies the data from articles to articles2. There isn’t a quick and simple
-- way to tell PostgreSQL to create a jsonb value with all the columns, except id and description,
-- so we create a jsonb value with all the columns and then remove id and description from the
-- jsonb, which is done by setting these keys to NULL and then REMOVING ALL THE KEYS that are set to NULL




-- Example : expose JSON data using a view: 
-- If some of your columns are collated in a single JSON column, you can still 
-- use a view to expose them as if they were stored in a relational way, 
CREATE VIEW articles3 AS
SELECT id, description, 
  CAST(j->>'quantity' AS int) AS quantity, 
  CAST(j->>'feet' AS float) AS feet, 
  CAST(j->>'inches' AS float) AS inches, 
  CAST(j->>'meters' AS float) AS meters, 
  CAST(j->>'pints' AS float) AS pints, 
  CAST(j->>'liters' AS float) AS liters, 
  CAST(j->>'gallons' AS float) AS gallons, 
  CAST(j->>'kg' AS float) AS kg, 
  CAST(j->>'ounces' AS float) AS ounces, 
  CAST(j->>'pounds' AS float) AS pounds
FROM articles2;

-- There’s more...
-- You can use column statistics to predict which columns are sparse, so you know which columns
-- might benefit from being moved into a JSON column.

-- 1- First, we need to run ANALYZE to collect the statistics on the articles table, 
-- because it didn’t get enough row changes to trigger automatic ANALYZE:
ANALYZE articles;

-- 2- At this point, we can see the fraction of NULL values in each column using this simple query
SELECT attname, null_frac FROM pg_stats
WHERE tablename = 'articles'
ORDER BY null_frac;

-- You can see how the statistics correctly record the fact that id and description 
-- do not have NULL values, while the other columns have at least 50% NULLs, with most 
-- columns being entirely NULL except, at most, one value.
-- JSON values with several fields can be indexed using GIN indexes, similar to arrays. This allows
-- queries using operators that check the existence of given keys, such as ?, ?|, and ?&, plus the
-- containment operator and the jsonpath operators, which can perform more elaborate checks.

-- Of course, it is also possible to use traditional B-tree indexes to optimize access to the values of
-- specific keys. Therefore, if you want to index a single field within a JSON object, we recommend
-- using a B-tree index. Just write an expression that extracts that value, like the ones we used in
-- the definition of the view. 

