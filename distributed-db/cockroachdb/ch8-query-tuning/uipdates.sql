
EXPLAIN ANALYZE
UPDATE USERS u SET credit_card='9999804075' 
WHERE city='rome' 
   AND name='Anna Massey' 
   AND address='75977 Donna Gateway Suite 52';
  
-- STORING clause in this index actually hurts performance. Because the credit_card 
-- number is changing,  the index will have to be updated as well as the base table.
CREATE  INDEX users_city_name_add_cc_idx ON users(city,name,address) STORING(credit_card);

EXPLAIN ANALYZE UPDATE USERS u SET credit_card='9999804075' 
WHERE 
   city='rome' 
   AND name='Anna Massey' 
   AND address='75977 Donna Gateway Suite 52';
  
DROP  INDEX users_city_name_add_cc_idx;
 
-- The correct index to optimize the update would be So while STORING columns that appear in the 
-- SELECT list is often a good practice, STORING columns in the SET list can be counterproductive.
CREATE  INDEX users_city_name_add_idx ON users(city,name,address);

EXPLAIN ANALYZE UPDATE USERS u SET credit_card='9999804075' 
WHERE 
   city='rome' 
   AND name='Anna Massey' 
   AND address='75977 Donna Gateway Suite 52';
  
DROP INDEX users_city_name_add_idx ;

SELECT * FROM USERS u ORDER BY credit_card DESC LIMIT 10


