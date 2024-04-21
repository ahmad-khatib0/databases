CREATE TABLE cats6
  ( 
     cat_id INT NOT NULL AUTO_INCREMENT, 
     name   VARCHAR(100), 
     breed  VARCHAR(100), 
     age    INT, 
     PRIMARY KEY (cat_id) 
  ); 
  INSERT INTO cats6(name, breed, age) 
VALUES ('Ringo', 'Tabby', 4),
       ('Cindy', 'Maine Coon', 10),
       ('Dumbledore', 'Maine Coon', 11),
       ('Egg', 'Persian', 4),
       ('Misty', 'Tabby', 13),
       ('George Michael', 'Ragdoll', 9),
       ('Jackson', 'Sphynx', 7);  

-- Various Simple SELECT statements:
SELECT * FROM cats; 
SELECT cat_id FROM cats;

-- mulltiple SELECT  
SELECT name, age FROM cats; 
SELECT cat_id, name, age, breed FROM cats;  --notice retravied data will be as the order you wrote in this line 




--  The WHERE  method  :  Select by age:
SELECT * FROM cats WHERE age=4;
SELECT * FROM cats WHERE name='Egg'; 
SELECT * FROM cats WHERE name='egG';  ---notice that for now sql its not case senstive  
SELECT cat_id, age FROM cats WHERE cat_id=age;  --SHOWS you the cats that have the same id as their ages 
SELECT article, color, shirt_size, last_worn FROM shirts WHERE shirt_size='M';




--  Introduction to Aliases : it will just RETURN the data but with another name for the COLUMNS ,
--  and this just for the displaying status  ,it means that won't affect the orginal COLUMNS' TABLE NAMES (label)  
SELECT cat_id AS id, name FROM cats;
SELECT name AS 'cat name', breed AS 'kitty breed' FROM cats;
DESC cats;




-- The UPDATE Command   CODE: Updating Data
Change tabby cats to shorthair:
UPDATE cats SET breed='Shorthair' WHERE breed='Tabby'; 

Another update:
UPDATE cats SET age=14 WHERE name='Misty'; 
update cats set cat_id =14 where breed='Not ragdoll';




--  DELETING DATA
DELETE FROM cats WHERE name='Egg';
DELETE FROM cats WHERE cat_id=age;
DELETE FROM cats; --this will DELETE  all the recored inside this TABLE  and not the TABLE itself 





