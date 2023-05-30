SELECT  (2)  ;   -- type =>  integer 

SELECT  (2.0)  ;   -- type =>  numeric 

SELECT  (2.0::INTEGER)  ;   -- type =>  forced to be integer, (or any num type)


SELECT ("true"::BOOLEAN) ; -- [true || 'yes' || 'on' || 't' || 'y' || 1 ]   if you insert one 
-- of these into a column that has a BOOLEAN type,  it will convert it to true  

SELECT ("false"::BOOLEAN) ; -- [false || 'no' || 'off' || '0' || 'f' || n ]   if you insert one 
-- of these into a column that has a BOOLEAN type,  it will convert it to false 

SELECT COALESCE((4)::BOOLEAN::INTEGER, 0)  -- => returns 1 
--- COALESCE returns the first not null value from given values

SELECT COALESCE((NULL)::BOOLEAN::INTEGER, 0)  -- => returns 0  

SELECT (NULL)::BOOLEAN::INTEGER  --- returns null 
