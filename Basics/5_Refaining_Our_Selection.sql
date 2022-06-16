SELECT DISTINCT author_lname FROM books;
SELECT DISTINCT CONCAT(author_fname,' ', author_lname) FROM books;
SELECT DISTINCT author_fname, author_lname FROM books;



SELECT title FROM books ORDER BY title; --by default its ASC
SELECT author_lname FROM books ORDER BY author_lname DESC;
SELECT released_year FROM books ORDER BY released_year DESC;

SELECT title, released_year, pages FROM books ORDER BY released_year ; --title , pages here won't be sorted
SELECT title, author_fname, author_lname FROM books ORDER BY 3;  -- 3 is refers to the index of the argumnet
SELECT title, author_fname, author_lname  FROM books ORDER BY 1 DESC;

SELECT author_fname, author_lname FROM books ORDER BY  author_fname , author_lname;







SELECT title FROM books LIMIT 3;
SELECT title, released_year FROM books  ORDER BY released_year DESC LIMIT 5;
SELECT title, released_year FROM books ORDER BY released_year DESC LIMIT 0,5; --here it starts counting from 0
SELECT title, released_year FROM books ORDER BY released_year DESC LIMIT 10,1; --starts from 11 and retrun 1 book
SELECT * FROM books LIMIT 9,18446744073709551615; --there is no way to put the end of table rather than this gaigantic number







SELECT title FROM books WHERE title LIKE '%the%'; --% are called wildcards , and they mean anything  ,
--any charcters exist BEFORE  the or any characters AFTER  the
SELECT title, author_fname FROM books WHERE author_fname LIKE 'da%';--da here won't be anything BEFORE  it
SELECT title FROM books WHERE  title LIKE 'the'; --won't give you anything, you don't have title book has only the as title
SELECT title FROM books WHERE  title LIKE '%the'; --won't give you anything, you don't have title book ends with the


SELECT title, stock_quantity FROM books WHERE stock_quantity LIKE '____';
--its 4 underscore , its mean SELECT stock_quantitys that have 4 digits or characters ,
SELECT title, stock_quantity FROM books WHERE stock_quantity LIKE '__';
--its 2 underscore , its mean SELECT stock_quantitys that have 2 digits or characters ,

(235)234-0987 LIKE '(___)___-____' --this could by an apply for this things


SELECT title FROM books WHERE title LIKE '%\%%' --this is Escape if you want to search about somthing contains %
SELECT title FROM books WHERE title LIKE '%\_%' --this is Escape if you want to search about somthing contains _
select title as title  from books where title like "%stories%" ;

SELECT CONCAT(title, ' - ', released_year) AS summary FROM books ORDER BY released_year DESC LIMIT 3;
SELECT title, author_lname FROM books WHERE author_lname LIKE '% %';  --thoes contain space in author_lname 
SELECT title, author_lname FROM books ORDER BY author_lname, title;
SELECT title, author_lname FROM books ORDER BY 2,1;
SELECT CONCAT('MY FAVORITE AUTHOR IS ',
        UPPER(author_fname), ' ', UPPER(author_lname),'!') AS yell FROM books ORDER BY author_lname;
