-- this how to run file in cli
source file_name.sql -- if you want to excute file in another der
source DirName / file.name.sql


CONCAT(column, 'text', anotherColumn, 'more text') 
CONCAT(author_fname, ' ', author_lname)
CONCAT(author_fname, author_lname);
-- invalid syntax

SELECT CONCAT(author_fname, ' ', author_lname) AS 'full name' FROM books;
SELECT author_fname AS first, author_lname AS last, CONCAT(author_fname, ' ', author_lname) AS full  FROM books;

SELECT CONCAT(title, '-', author_fname, '-', author_lname) FROM books;
--or
SELECT CONCAT_WS(' - ', title, author_fname, author_lname)  FROM books;
SELECT CONCAT_WS(' - ', title, author_fname, author_lname)  FROM books;
Consider the Lobster - David - Foster Wallace,,,,,,,,,
--CONCAT_WS is a way for spiritng retriaved data with somethingg like - , . \ '' ...


SELECT SUBSTRING('Hello World', 3, 8);
--Hello Wo :notice the counting starts from 1 not zero
SELECT SUBSTRING('Hello World', 3);
-- llo World : notice one arg returns from that arg till END
SELECT SUBSTRING('Hello World', -7);
--o World : negative starts counting from the end
SELECT SUBSTRING(title, 1, 10) AS 'short title' FROM books;
SELECT CONCAT (SUBSTRING (title, 1, 10)  ,  '...') AS 'short title'  FROM books;




SELECT REPLACE('Hello World', 'o', '0'); -- Hell0 W0rld
SELECT REPLACE('HellO World', 'o', '*'); 
--  HellO W*rld : notice that REPLACE  is case senstive, so it didn't REPLACE  capital O letter
SELECT REPLACE('cheese bread coffee milk', ' ', ' and '); --cheese and bread and coffee and milk
SELECT SUBSTRING(REPLACE(title, 'e', '3'), 1, 10)   AS   'weird string'  FROM books;






SELECT REVERSE('Hello World');  --| dlroW olleH
SELECT CONCAT('woof', REVERSE('woof'));  -- wooffoow
SELECT CONCAT(author_fname, REVERSE(author_fname)) FROM books;




SELECT CHAR_LENGTH('Hello World');  --11
SELECT author_lname, CHAR_LENGTH(author_lname) AS 'length' FROM books; -- author_lname length |  Lahiri   6 ,,,,,
SELECT CONCAT(author_lname, ' is ', CHAR_LENGTH(author_lname), ' characters long') FROM books;





SELECT UPPER('Hello World');  -- HELLO WORLD
SELECT LOWER('Hello World');  --hello world
SELECT CONCAT('MY FAVORITE BOOK IS ', UPPER(title)) FROM books;
SELECT CONCAT('MY FAVORITE BOOK IS ', LOWER(title)) FROM books;




SELECT
   CONCAT(SUBSTRING(title, 1, 10), '...') AS 'short title',
   CONCAT(author_lname, ',', author_fname) AS author,
   CONCAT(stock_quantity, ' in stock') AS quantity
FROM books ;