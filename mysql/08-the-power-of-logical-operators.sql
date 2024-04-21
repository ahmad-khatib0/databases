SELECT title, author_lname FROM books WHERE author_lname != 'Harris';
SELECT title FROM books WHERE released_year != 2017;






SELECT title FROM books WHERE title NOT LIKE 'W%';




 
SELECT title, released_year FROM books WHERE released_year > 2000 ORDER BY released_year;
SELECT title, released_year FROM books WHERE released_year >= 2000 ORDER BY released_year; 
SELECT title, stock_quantity FROM books WHERE stock_quantity >= 100;
 
SELECT 99 > 1;  --in mysql 1 is mean trure and 0 is means flase 
SELECT 99 > 567;
 
SELECT 100 > 5   -- 1 :  true
SELECT -15 > 15  -- false
SELECT 9 > -10  -- true
SELECT 1 > 1 -- false  

SELECT 'a' > 'b'  -- false --in MYSQL IN STRINGS, WHAT COMES AFTER IS GREATER 
SELECT 'A' > 'a'  -- false :BECAUSE ITS EQUAL 
SELECT 'A' >=  'a' -- true
 
SELECT title, author_lname FROM books WHERE author_lname = 'Eggers'; --ITS TRUE 
SELECT title, author_lname FROM books WHERE author_lname = 'eggers'; --ITS TRUE 
SELECT title, author_lname FROM books WHERE author_lname = 'eGGers'; --ITS TRUE 




 
SELECT title, released_year FROM books WHERE released_year < 2000;
SELECT title, released_year FROM books  WHERE released_year <= 2000;
SELECT 3 < -10;  -- false
 
SELECT -10 < -9;  -- true
 
SELECT 42 <= 42;  -- true
 
SELECT 'h' < 'p';  -- true
 
SELECT 'Q' <= 'q';  -- true







SELECT title, author_lname, released_year FROM books  WHERE author_lname='Eggers';
 
SELECT title, author_lname, released_year FROM books  WHERE released_year > 2010;
 
SELECT   title,  author_lname,  released_year FROM books
WHERE author_lname='Eggers'  AND released_year > 2010;
 
SELECT 1 < 5 && 7 = 9;        -- false
SELECT -10 > -20 && 0 <= 0;    -- true
SELECT -40 <= 0 AND 10 > 40;   --false
SELECT 54 <= 54 && 'a' = 'A';  -- true
 
SELECT * FROM books
WHERE author_lname='Eggers'  AND released_year > 2010  AND title LIKE '%novel%';
-- Please note, as of MySQL 8.0.17, the && operator is deprecated and support for it will be removed in a 
-- future MySQL version. Applications should be adjusted to use the standard SQL AND operator.
-- If you're using MySQL 5.7 or older, which most of you are if you're using GoormIDE, then you don't have to
--  worry about this right now. But, in newer versions of MySQL (8.0.17 and newer) you will need to replace && 
-- with AND.     THE SAME THINGS ARE APPLAYED FOR  \\ , SO YOU NEED TO REPLACE  IT WITH OR 






SELECT  title,  author_lname,  released_year  FROM books
WHERE author_lname='Eggers' || released_year > 2010;
 
SELECT 40 <= 100 || -2 > 0;    -- true
SELECT 10 > 5 || 5 = 5;    -- true
SELECT 'a' = 5 || 3000 > 2000;    -- true

SELECT title,  author_lname,  released_year,  stock_quantity  FROM   books 
WHERE  author_lname = 'Eggers' || released_year > 2010 OR     stock_quantity > 100;







SELECT title, released_year FROM books WHERE released_year >= 2004 && released_year <= 2015;

SELECT title, released_year FROM books  WHERE released_year BETWEEN 2004 AND 2015;
SELECT title, released_year FROM books WHERE released_year NOT BETWEEN 2004 AND 2015;
 
SELECT name, birthdt FROM people WHERE birthdt BETWEEN '1980-01-01' AND '2000-01-01';
SELECT CAST('2017-05-02' AS DATETIME); --THIS IS BETTER TO CONVERT DATE STRING TO AN ACTUAL DATETIME 
 
SELECT  name,  birthdt FROM people
WHERE birthdt BETWEEN CAST('1980-01-01' AS DATETIME)
                            AND CAST('2000-01-01' AS DATETIME);








SELECT title, author_lname FROM books WHERE author_lname IN ('Carver', 'Lahiri', 'Smith'); 
SELECT title, released_year FROM books WHERE released_year IN (2017, 1985);
SELECT title, released_year FROM books
WHERE released_year != 2000 AND
      released_year != 2002 AND
      released_year != 2004 AND
      released_year != 2006 AND
      released_year != 2008 AND
      released_year != 2010 AND
      released_year != 2012 AND
      released_year != 2014 AND
      released_year != 2016;
 
SELECT title, released_year FROM books
WHERE released_year NOT IN (2000,2002,2004,2006,2008,2010,2012,2014,2016); --THIS IS LOOOOONG WAY 
 
SELECT title, released_year FROM books
WHERE released_year >= 2000 AND released_year % 2 != 0 ORDER BY released_year;  --THIS IS SHORTER WAY 









SELECT title, released_year,
       CASE 
         WHEN released_year >= 2000 THEN 'Modern Lit'  --THIS TO TROW IT AS A NEW CELL  IN THE TABLE 
         ELSE '20th Century Lit'
       END AS GENRE  --THIS IS THE NAME OF THAT NEW COLUMN  
FROM books;
 
 
SELECT title,
    CASE 
        WHEN stock_quantity BETWEEN 0 AND 50 THEN '*'
        WHEN stock_quantity BETWEEN 51 AND 100 THEN '**'
        ELSE '***'
    END AS STOCK
FROM books;
 
SELECT title, stock_quantity,
    CASE 
        WHEN stock_quantity BETWEEN 0 AND 50 THEN '*'    --BETWEEN  AND IS A LITTLE BIT LONGER  
        WHEN stock_quantity BETWEEN 51 AND 100 THEN '**'
        WHEN stock_quantity BETWEEN 101 AND 150 THEN '***'
        ELSE '****'
    END AS STOCK
FROM books;
 
SELECT title, stock_quantity,
    CASE 
        WHEN stock_quantity <= 50 THEN '*'     -- USING <= IS RELATIVALLY SHORTER  
        WHEN stock_quantity <= 100 THEN '**'
        ELSE '***'
    END AS STOCK
FROM books; 












-- CODE: Logical Operators Exercises Solution
SELECT 10 != 10;     -- false
SELECT 15 > 14 && 99 - 5 <= 94;     -- true
SELECT 1 IN (5,3) || 9 BETWEEN 8 AND 10;     -- true
  
SELECT title, author_lname FROM books WHERE author_lname='Eggers' OR author_lname='Chabon';
SELECT title, author_lname FROM books WHERE author_lname IN ('Eggers','Chabon');
 
SELECT title, author_lname, released_year FROM books WHERE author_lname = 'Lahiri' && released_year > 2000;
 
SELECT title, pages FROM books WHERE pages >= 100 && pages <=200;
SELECT title, pages FROM books WHERE pages BETWEEN 100 AND 200;


SELECT  title,  author_lname  FROM books 
WHERE   author_lname LIKE 'C%' OR   author_lname LIKE 'S%';
SELECT    title,    author_lname  FROM books 
WHERE    SUBSTR(author_lname,1,1) = 'C' OR    SUBSTR(author_lname,1,1) = 'S';
SELECT title, author_lname FROM books WHERE SUBSTR(author_lname,1,1) IN ('C', 'S');
 
SELECT    title,    author_lname,
    CASE
        WHEN title LIKE '%stories%' THEN 'Short Stories'
        WHEN title = 'Just Kids' OR title = 'A Heartbreaking Work of Staggering Genius' THEN 'Memoir'
        ELSE 'Novel'
    END AS TYPE
FROM books;
 
SELECT author_fname, author_lname,
    CASE 
        WHEN COUNT(*) = 1 THEN '1 book'
        ELSE CONCAT(COUNT(*), ' books')
    END AS COUNT
FROM books 
GROUP BY author_lname, author_fname;