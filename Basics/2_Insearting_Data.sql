-- Inserting Data
-- The "formula":
INSERT INTO table_name(column_name) VALUES (data);
-- For example:
INSERT INTO cats(name, age) VALUES ('Jetson', 7);


-- show every thing in table 
SELECT * FROM cats; 




INSERT INTO table_name 
            (column_name, column_name) 
VALUES      (value, value), 
            (value, value), 
            (value, value);




-- how to insert a string (VARCHAR) value that contains quotations, You can do it a couple of ways:

Escape the quotes with a backslash: "This text has \"quotes\" in it" or 'This text has \'quotes\' in it'

Alternate single and double quotes: "This text has 'quotes' in it" or 'This text has "quotes" in it'



-- MySQL Warnings Code : Try Inserting a cat with a super long name:

INSERT INTO cats(name, age)
VALUES('This is some text blah blah blah blah blah text text text something about cats lalalalal meowwwwwwwwwww', 10);
-- Then view the warning:
SHOW WARNINGS; 

-- Try inserting a cat with incorrect data types:
INSERT INTO cats(name, age) VALUES('Lima', 'dsfasdfdas'); 

-- Then view the warning:
SHOW WARNINGS; 


-- the YES filed or keyword in any  column  is mean its allowed or premited to this insert to be empty 
-- Define a new cats2 table with NOT NULL constraints:
CREATE TABLE cats2
  (
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL
  );
DESC cats2; 

-- Now try inserting an ageless cat:
INSERT INTO cats2(name) VALUES('Texas');  --AGE will be set to zero 

View the new warnings:
SHOW WARNINGS;     -- Field 'age' doesn't have a default value
SELECT * FROM cats2; 

Do the same for a nameless cat:
INSERT INTO cats2(age) VALUES(7);  --NAME will be an empty filed  
SHOW WARNINGS;   --Field 'name' doesn't have a default value




-- Setting Default Values  : Define a table with a DEFAULT name specified:

CREATE TABLE cats3
  (
    name VARCHAR(20) DEFAULT 'no name provided',
    age INT DEFAULT 99
  );
-- Notice the change when you describe the table:   DESC cats3; 

-- Insert a cat without a name -- Or a nameless, ageless cat:
INSERT INTO cats3(age) VALUES(13); 
INSERT INTO cats3() VALUES(); 



-- Combine NOT NULL and DEFAULT:
CREATE TABLE cats4
  (
    name VARCHAR(20) NOT NULL DEFAULT 'unnamed',
    age INT NOT NULL DEFAULT 99
  );
  
-- Notice The Difference:
INSERT INTO cats() VALUES();
SELECT * FROM cats;
-- NULL /  NULL  

INSERT INTO cats3() VALUES();
SELECT * FROM cats3;
--  unnamed |   99
 
INSERT INTO cats3(name, age) VALUES('Montana', NULL); 
SELECT * FROM cats3;
-- Montana | NULL
 
INSERT INTO cats4(name, age) VALUES('Cali', NULL);
-- ERROR 1048 (23000): Column 'age' cannot be null






-- Primary Keys
-- Define a table with a PRIMARY KEY constraint:

CREATE TABLE unique_cats
  (
    cat_id INT NOT NULL,
    name VARCHAR(100),
    age INT,
    PRIMARY KEY (cat_id)
  );

-- Insert some new cats:
INSERT INTO unique_cats(cat_id, name, age) VALUES(1, 'Fred', 23);  --ok 
INSERT INTO unique_cats(cat_id, name, age) VALUES(2, 'Louise', 3); --ok
INSERT INTO unique_cats(cat_id, name, age) VALUES(1, 'James', 3); 
-- ERROR 1062 (23000): Duplicate entry '1' for key 'unique_cats.PRIMARY'



-- Adding in AUTO_INCREMENT:
CREATE TABLE unique_cats2 (
    cat_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100),
    age INT,
    PRIMARY KEY (cat_id)
);

-- INSERT a couple new cats:
INSERT INTO unique_cats2(name, age) VALUES('Skippy', 4);
INSERT INTO unique_cats2(name, age) VALUES('Jiff', 3);
INSERT INTO unique_cats2(name, age) VALUES('Jiff', 3);
INSERT INTO unique_cats2(name, age) VALUES('Jiff', 3);
INSERT INTO unique_cats2(name, age) VALUES('Skippy', 4);
-- this solved tow proplems : 1 you don't have to worry about inserting ides by youself , 
-- 2 you can to have many inserts with the same VALUES  but with diffrent ides 



-- Another way of defining a primary key:
CREATE TABLE employees2 (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    middle_name VARCHAR(255),
    age INT NOT NULL,
    current_status VARCHAR(255) NOT NULL DEFAULT 'employed'
);