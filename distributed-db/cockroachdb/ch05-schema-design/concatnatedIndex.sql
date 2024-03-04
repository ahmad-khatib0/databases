/* Explaining various indexing options */

DROP TABLE people;

CREATE TABLE people AS 
SELECT 
  p.firstname ,
  p.lastname ,
  e2.emailaddress ,
  a2.addressline1,
  a2.addressline2 ,
  s2.name AS state,
  c2.name AS country,
  p2.phonenumber
FROM person p 
  JOIN businessentity b USING (businessentityid) 
  JOIN businessentityaddress b2 USING (businessentityid) 
  JOIN address a2 USING (addressid)
  JOIN stateprovince s2 USING(stateprovinceid)
  JOIN countryregion c2 USING (countryregioncode)
  JOIN personphone p2 USING (businessentityid) 
  JOIN emailaddress e2 USING (businessentityid)  ;

 
SELECT lastname,firstname,count(*) FROM people GROUP BY 1,2 ORDER BY 3 DESC ;
 
EXPLAIN analyze SELECT phonenumber FROM people 
WHERE lastname='Smith' 
   AND firstname='Samantha' AND state='California' ;
  
CREATE INDEX people_firstname_ix ON people(firstname)  ;
SELECT lastname,firstname,count(*) FROM people GROUP BY 1,2 ORDER BY 3 DESC ;
 
EXPLAIN analyze
SELECT phonenumber FROM people 
WHERE lastname='Smith' 
   AND firstname='Samantha' AND state='California' ;
  
CREATE INDEX people_lastname_ix ON people(lastname)  ;
EXPLAIN analyze SELECT phonenumber FROM people 
WHERE lastname='Smith' 
   AND firstname='Samantha' AND state='California' ;
  
DROP INDEX people_firstname_ix;
EXPLAIN analyze SELECT phonenumber FROM people 
 WHERE lastname='Smith' 
   AND firstname='Samantha' AND state='California' ;
  
CREATE INDEX people_lastfirst_ix ON people (lastname,firstname) ;
EXPLAIN analyze SELECT phonenumber FROM people 
 WHERE lastname='Smith' 
   AND firstname='Samantha' AND state='California';  
  
CREATE INDEX people_lastfirststate_ix ON people (lastname,firstname,state) ;
EXPLAIN analyze
SELECT phonenumber FROM people 
 WHERE lastname='Smith' 
   AND firstname='Samantha' AND state='California';
  
  
   
CREATE INDEX people_lastfirststatephone_ix ON people (lastname,firstname,state) STORING (phonenumber);
EXPLAIN analyze
SELECT phonenumber FROM people 
WHERE lastname='Smith' 
   AND firstname='Samantha' AND state='California';
  
 
EXPLAIN 
SELECT phonenumber FROM people 
 WHERE lastname='Smith' 
   AND firstname='Samantha' AND state='California';

  
