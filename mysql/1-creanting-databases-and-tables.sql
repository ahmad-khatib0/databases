Start the CLI:
mysql-ctl cli; 

List available databases:
show databases; 

The general command for creating a database:
CREATE DATABASE database_name; 

A specific example:
CREATE DATABASE soap_store; 

-- 
To drop a database:
DROP DATABASE database_name; 


USE <database name>;
USE dog_walking_app;
-- this is for switching to this database 
 

SELECT database();  
-- this show to us which DATABASE  we are on now 



-- 
CREATE TABLE tablename 
( column_name data_type, column_name data_type); 
-- for exampel 
CREATE TABLE cats 
  ( 
     name VARCHAR(100),
     age  INT 
  ); 



SHOW COLUMNS FROM <tablename>;
-- Or...
DESC <tablename>;
-- DESC is a short for saying describe 




Dropping Tables
DROP TABLE <tablename>;
