CREATE TABLE items(price DECIMAL(5,2));
INSERT INTO items(price) VALUES(7); --  7.00 
 
INSERT INTO items(price) VALUES(7987654); --ERROR 1264 (22003): Out of range value for column 'price' at row 1
 
INSERT INTO items(price) VALUES(34.88);  --34.88
 
INSERT INTO items(price) VALUES(298.9999); --299.00 : decimal is more than 2 digits, so its get ruond to +1

INSERT INTO items(price) VALUES(1.9999);   --2  :decimal is more than 2 digits, so its get ruond to +1
SELECT * FROM items;





CREATE TABLE thingies (price FLOAT);
INSERT INTO thingies(price) VALUES (88.45);   --88.45
INSERT INTO thingies(price) VALUES (8877.45);   -- 8877.45
INSERT INTO thingies(price) VALUES (8877665544.45);   --  8877670000 
SELECT * FROM thingies;






CREATE TABLE people (name VARCHAR(100), birthdate DATE, birthtime TIME, birthdt DATETIME);

INSERT INTO people (name, birthdate, birthtime, birthdt)
VALUES('Padma', '1983-11-11', '10:07:35', '1983-11-11 10:07:35'); 
INSERT INTO people (name, birthdate, birthtime, birthdt)
VALUES('Larry', '1943-12-25', '04:10:42', '1943-12-25 04:10:42');

INSERT INTO people (name, birthdate, birthtime, birthdt)
VALUES('Ahmad', CURDATE() , CURTIME() , NOW()); --INSERT THEM AUTO : use the belwo method its easer to remember
SELECT * FROM people;

SELECT name, birthdate FROM people;
SELECT name, DAY(birthdate) FROM people;
 
SELECT name, birthdate, DAY(birthdate) FROM people; 
SELECT name, birthdate, DAYNAME(birthdate) FROM people;
SELECT name, birthdate, DAYOFWEEK(birthdate) FROM people;
SELECT name, birthdate, DAYOFYEAR(birthdate) FROM people;
SELECT name, birthtime, DAYOFYEAR(birthtime) FROM people;  --this won't work correctly 

SELECT name, birthdt, DAYOFYEAR(birthdt) FROM people;    --insteas this goona work 
SELECT name, birthdt, MONTH(birthdt) FROM people;
SELECT name, birthdt, MONTHNAME(birthdt) FROM people;

SELECT name, birthtime, HOUR(birthtime) FROM people;
SELECT name, birthtime, MINUTE(birthtime) FROM people;
 
SELECT CONCAT(MONTHNAME(birthdate), ' ', DAY(birthdate), ' ', YEAR(birthdate)) FROM people; --its hard 

SELECT DATE_FORMAT(birthdt, 'Was born on a %W') FROM people;        -- DATETIME       
SELECT DATE_FORMAT(birthdt, '%m/%d/%Y') FROM people;                -- DATETIME      
SELECT DATE_FORMAT(birthdt, '%m/%d/%Y at %h:%i') FROM people ;      -- DATETIME





SELECT * FROM people;
SELECT name, birthdate, DATEDIFF(NOW(), birthdate) FROM people; --THE RESAULT IN DAYS 
SELECT birthdt FROM people;
 
SELECT birthdt, DATE_ADD(birthdt, INTERVAL 1 MONTH) FROM people;  --INTERVAL MEANS  INSIDE 
SELECT birthdt, DATE_ADD(birthdt, INTERVAL 10 SECOND) FROM people;
SELECT birthdt, DATE_ADD(birthdt, INTERVAL 3 QUARTER) FROM people;
 
SELECT birthdt, birthdt + INTERVAL 1 MONTH FROM people;
SELECT birthdt, birthdt - INTERVAL 5 MONTH FROM people;
SELECT birthdt, birthdt + INTERVAL 15 MONTH + INTERVAL 10 HOUR FROM people; --MULTIIPLE ADDS











CREATE TABLE comments ( content VARCHAR(100), created_at TIMESTAMP DEFAULT NOW() );
--  timestamp has a range of '1970-01-01 00:00:01' UTC to '2038-01-19 03:14:07' UTC. 
-- default is nessarry here to put it , and set it to now  
INSERT INTO comments (content) VALUES('lol what a funny article');
INSERT INTO comments (content) VALUES('I found this offensive');
INSERT INTO comments (content) VALUES('Ifasfsadfsadfsad');
 
SELECT * FROM comments ORDER BY created_at DESC;
 
CREATE TABLE comments2 ( content VARCHAR(100), 
changed_at TIMESTAMP DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP);
--you can to REPLACE  current_timestamp with the now() fonction 
INSERT INTO comments2 (content) VALUES('dasdasdasd');
INSERT INTO comments2 (content) VALUES('lololololo');
INSERT INTO comments2 (content) VALUES('I LIKE CATS AND DOGS');
 
UPDATE comments2 SET content='THIS IS NOT GIBBERISH' WHERE content='dasdasdasd'; 
SELECT * FROM comments2; 
SELECT * FROM comments2 ORDER BY changed_at;











-- What's a good use case for CHAR?
-- Used for text that we know has a fixed length, e.g., State abbreviations,
--  abbreviated company names, sex M/F, etc.
 
CREATE TABLE inventory ( item_name VARCHAR(100), price DECIMAL(8,2), quantity INT);
 -- (price is always < 1,000,000)
 
-- What's the difference between DATETIME and TIMESTAMP?
-- They both store datetime information, but there's a difference in the range, TIMESTAMP has 
-- a smaller range. TIMESTAMP also takes up less space.  TIMESTAMP is used for things
--  like meta-data about when something is created or updated.
 
SELECT CURTIME();
SELECT CURDATE();
 
SELECT DAYOFWEEK(CURDATE());  or SELECT DAYOFWEEK(NOW());
SELECT DATE_FORMAT(NOW(), '%w') + 1; -- BY DEFAULT ITS SET TO 6 DAYS NOT 7 
 
SELECT DAYNAME(NOW());  OR  SELECT DATE_FORMAT(NOW(), '%W');
 
SELECT DATE_FORMAT(CURDATE(), '%m/%d/%Y');
SELECT DATE_FORMAT(NOW(), '%M %D at %h:%i');
 
CREATE TABLE tweets( content VARCHAR(140)  , username VARCHAR(20)  ,created_at TIMESTAMP DEFAULT NOW() );
 
INSERT INTO tweets (content, username) VALUES('this is my first tweet', 'coltscat');
INSERT INTO tweets (content, username) VALUES('this is my second tweet', 'coltscat');
 SELECT * FROM tweets;