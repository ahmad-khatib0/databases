SELECT COUNT(*) FROM books; 
SELECT COUNT(author_fname) FROM books;
SELECT COUNT(DISTINCT author_lname, author_fname) FROM books; 
SELECT COUNT(*) FROM books WHERE title LIKE '%the%';



 
SELECT author_lname, COUNT(*)  FROM books GROUP BY author_lname; 
SELECT title, author_fname, author_lname FROM books GROUP BY author_lname;
SELECT author_fname, author_lname, COUNT(*) FROM books GROUP BY author_lname; 
SELECT author_fname, author_lname, COUNT(*) FROM books GROUP BY author_lname, author_fname; 
SELECT released_year, COUNT(*) FROM books GROUP BY released_year;
SELECT CONCAT('In ', released_year, ' ', COUNT(*), ' book(s) released') AS year FROM books GROUP BY released_year;





SELECT MIN(released_year)  FROM books;
SELECT MAX(pages) FROM books;
 

SELECT * FROM books WHERE pages = 
                    (SELECT Min(pages) 
                     FROM books);  -- the second SELECT  called sub query  
SELECT title, pages FROM books 
WHERE pages = (SELECT Min(pages) 
                FROM books);  --the first potintial soluthion  --but its slower because there are 2 query here 
 
SELECT title, pages FROM books  --this is the second and this is faster 
ORDER BY pages ASC LIMIT 1;
SELECT * FROM books  ORDER BY pages DESC LIMIT 1;








SELECT author_fname, author_lname, Min(released_year) 
FROM   books GROUP  BY author_lname, author_fname;
 
SELECT author_fname, author_lname, Max(pages)  FROM books
GROUP BY author_lname, author_fname;
 
SELECT
  CONCAT(author_fname, ' ', author_lname) AS author,
  MAX(pages) AS 'longest book'
FROM books  GROUP BY author_lname, author_fname;









SELECT SUM(pages) FROM books; 
SELECT author_fname, author_lname, Sum(pages)  FROM books
GROUP BY  author_lname,  author_fname; 
SELECT author_fname,  author_lname,  Sum(released_year)  FROM books
GROUP BY  author_lname,  author_fname;






 
SELECT AVG(pages)  FROM books;
 
SELECT AVG(stock_quantity) FROM books  GROUP BY released_year;
 
SELECT released_year, AVG(stock_quantity) 
FROM books  GROUP BY released_year;  
SELECT author_fname, author_lname, AVG(pages) FROM books
GROUP BY author_lname, author_fnam 
-- we GROUP BY  here because we want to condence COLUMNS in order to calculate the avg FROM  them 







SELECT COUNT(*) FROM books GROUP BY released_year;
 
SELECT released_year, COUNT(*) FROM books GROUP BY released_year;
-- Print out how many books were released in each year
 
SELECT Sum(stock_quantity) FROM BOOKS;
SELECT author_fname, author_lname, AVG(released_year) FROM books GROUP BY author_lname, author_fname;
-- Find the average released_year for each author

SELECT CONCAT(author_fname, ' ', author_lname) FROM books WHERE pages = (SELECT Max(pages) FROM books); --OR :
SELECT CONCAT(author_fname, ' ', author_lname) FROM books  ORDER BY pages DESC LIMIT 1;
-- Find the full name of the author who wrote the longest book
 
SELECT released_year AS year,
    COUNT(*) AS '# of books',
    AVG(pages) AS 'avg pages'
FROM books
    GROUP BY released_year;