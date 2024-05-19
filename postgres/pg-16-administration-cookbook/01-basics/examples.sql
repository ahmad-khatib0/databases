SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP SCHEMA IF EXISTS myschema CASCADE;
CREATE SCHEMA myschema;

SET default_tablespace = '';
SET default_table_access_method = heap;
SET search_path = myschema;

CREATE TABLE mytable (
  id integer PRIMARY KEY,
  col1 text
);

CREATE TABLE mytable2 (
  id integer,
  fid integer REFERENCES mytable(id),
  col2 timestamp with time zone DEFAULT clock_timestamp(),
  PRIMARY KEY (id, fid)
);


INSERT INTO mytable(id, col1) values 
( 1,   'Ananas'),
( 2,   'Banana'), 
( 3,   'Cucumber'), 
( 4,   'Dasheen'), 
( 5,   'Endive');

INSERT INTO mytable2 (id, fid, col2) values
( 1001, 1,  '2023-11-15 18:49:14.84806+01' ), 
( 1001, 2,  '2023-11-15 18:49:14.848334+01' ),
( 1002, 5,  '2023-11-15 18:49:14.848344+01' );


