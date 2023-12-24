/* 
  measurements schema used in some examples
*/

USE chapter06;

CREATE SCHEMA measurements;

SET SCHEMA measurements;

DROP TABLE IF EXISTS measurements;
DROP TABLE IF EXISTS locations;

CREATE TABLE locations (
  id uuid primary KEY DEFAULT gen_random_uuid(),
  description STRING NOT NULL,
  last_measurement float,
  last_timestamp timestamp
);
                        
CREATE TABLE measurements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  locationId uuid NOT NULL ,
  measurement_timestamp timestamp DEFAULT now(),
  measurement float,
  CONSTRAINT measurement_fk1 FOREIGN KEY (locationId) REFERENCES locations(id)
);
                          
INSERT INTO locations (description )
WITH RECURSIVE series AS ( 
  SELECT 100 AS id
  UNION ALL 
 SELECT id -1 AS id
   FROM series
  WHERE id > 0 
) 

SELECT  md5(random()::STRING) randomString  FROM series;
 
SELECT * FROM measurements;
SEEL


