
-- We will illustrate MERGE using the example of a shop manager who records the amount of each
-- article in a database table. The manager will use the table to know which articles are running out
-- and to order the correct amount of articles at the right time.
CREATE TABLE articles ( 
  id int PRIMARY KEY, 
  description text NOT NULL, 
  quantity int NOT NULL
);

INSERT INTO articles (id, quantity, description) VALUES
  (1, 15, 'Aubergines'), 
  (2, 6,  'Bananas'), 
  (3, 34, 'Carrots'), 
  (4, 22, 'Dates (kg)');

-- Now, we create a temporary table representing the list of supplies that have been ordered:
CREATE TEMP TABLE new_articles (LIKE articles);

INSERT INTO new_articles (id, quantity, description) VALUES
  (2, 24, 'Bananas'), 
  (4, 50, 'Dates'), 
  (5, 12, 'Eclairs');

-- In order to merge new articles into articles, you can issue the following query:
MERGE INTO articles a
    USING new_articles n ON a.id = n.id
  WHEN MATCHED THEN
    UPDATE SET quantity = a.quantity + n.quantity
  WHEN NOT MATCHED THEN
    INSERT VALUES (n.id, n.description, n.quantity);

-- here for example you will see Bananas becomes 30 (24 + 6)


-- There’s more...
-- A similar outcome could be achieved with the INSERT ... ON CONFLICT syntax, which existed
-- already. However, MERGE is standard SQL, so it is preferrable to a PostgreSQL-only syntax. More-
-- over, those two commands are not entirely equivalent in terms of what they allow. The other SQL
-- statements that modify the rows matching a given subquery are DELETE FROM ... USING and
-- UPDATE ... WITH. They are also not equivalent to MERGE, as they don’t allow inserts.

