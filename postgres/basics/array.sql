CREATE TABLE public.purchases  
(  
    id   serial PRIMARY KEY,  
    purchaser varchar(50),  
    items_purchased jsonb  
);

INSERT INTO purchases (purchaser,items_purchased) VALUES ('Bob',  
 '[
    {  
      "productid": 1,  
      "name": "Dell 123 Laptop Computer",  
      "price": 1300
    },  
    {  
      "productid": 2,  
      "name": "Mechanical Keyboard",  
      "price": 120
    }  
 ]'
);
INSERT INTO purchases (purchaser,items_purchased) VALUES('Carol',  
'[{  
  "productid": 3,  
  "name": "Virtual Keyboard",  
  "price": 150}, {  
  "productid": 1,  
  "name": "Dell 123 Laptop Computer",  
  "price": 1300},  
 {  
  "productid": 8,  
  "name": "LG Ultrawide Monitor",  
  "price": 190}  
]');
INSERT INTO purchases (purchaser,items_purchased) VALUES ('Ted',  
'[{  
  "productid": 6,  
  "name": "Ergonomic Keyboard",  
  "price": 90},  
 {  
  "productid": 7,  
  "name": "Dell 789 Desktop Computer",  
  "price": 120}  
]');
INSERT INTO purchases (purchaser,items_purchased) VALUES('Alice',  
'[{  
  "productid": 7,  
  "name": "Dell 789 Desktop Computer",  
  "price": 120},  
 {  
  "productid": 2,  
  "name": "Mechanical Keyboard",  
  "price": 120}  
]');




SELECT arr.position,arr.item_object  
  FROM purchases,  
  jsonb_array_elements(items_purchased) with ordinality arr(item_object, position)   
WHERE id=2;

-- jsonb_array_elements This breaks the array in to separate json objects.

-- with ordinality. This tells PostgreSQL to include the ordinal position. 
   -- Note this starts at 1. But when dealing with array, it starts at 0.

-- The word position is a key word.


SELECT arr.item_object  
  FROM purchases,jsonb_array_elements(items_purchased) with ordinality arr(item_object, position)   
WHERE id=2 and arr.position=2;
--  get just the second item purchased by Carol, id=2.

-- or using: 
SELECT arr.item_object
FROM purchases,jsonb_array_elements(items_purchased) with ordinality arr(item_object, position) 
WHERE id=2 and arr.position=Cast(
  (select arr.position  
    FROM purchases, jsonb_array_elements(items_purchased) with ordinality arr(item_object, position) 
    WHERE id=2 and arr.item_object->>'productid' = '1') as int
  )
-- The ->> operator will return the value of the Key (productid) contained in 
   -- item_object as text. That is why we use ‘1’ even though productid is a number.
  
-- Even though the ordinal position is a bigint, we must Cast it to int or bigint.




SELECT arr.item_object, arr.item_object->> 'price'
  FROM purchases,
    jsonb_array_elements(items_purchased) with ordinality arr(item_object, position) 
  WHERE id=2
  AND arr.item_object->>'price' = Cast(
      (
            SELECT MAX(item_prices.price) as p FROM purchases,
            jsonb_to_recordset(purchases.items_purchased) as item_prices(price int)
            WHERE id=2
      ) AS VARCHAR
    );
    
-- get the highest price item purchased by Carol, id=2.

--  the jsonb_to_recordset() function allows us to extract data out in to 
    -- relational columns, against which we can query.



UPDATE purchases SET items_purchased = 
   items_purchased || '{"name": "LG Ultrawide Monitor", "price": 190, "productid": 8}' ::jsonb
WHERE id=1;
-- add a purchase to the items_purchased array for Bob, id=1.

-- we have used the concatenation operator, ||, to concatenate on to the array a jsonb objects



UPDATE purchases SET items_purchased = 
    COALESCE(items_purchased, '[]'::jsonb) 
      || 
    '{"name": "LG Ultrawide Monitor", "price": 190, "productid": 8}' ::jsonb
WHERE id=1;
-- Special case — no existing purchases. If items_purchased is null,
-- so we substituted and empty array and then concatenated because you cannot concatenate on to null.



SELECT position FROM purchases, 
  jsonb_array_elements(items_purchased) with ordinality arr(item_object, position) 
WHERE id=2 AND item_object->>'productid' = '1';



UPDATE purchases SET items_purchased = 
  items_purchased - Cast(
    (
      SELECT position - 1 
        FROM purchases, 
        jsonb_array_elements(items_purchased) with ordinality arr(item_object, position) 
      WHERE id=2 AND item_object ->> 'productid' = '1'
    ) 
  as int)
WHERE id=2;

-- this deletes an object from Carol's items_purchased (the 2th object)
-- We used a a query to find the position in Carol’s items_purchased for productid=1.
    -- This returned ordinal position 2. Therefore we used position-1 to get array location 1.

-- Even though the ordinal position is a bigint, we must Cast it to int or bigint.

-- the ->> returns a string so in item_object->>’productid’ = ‘1’ we compare against the 
    -- string version of the productid, even though it is a number in the json.

-- Indexing the whole Column 
CREATE INDEX idx_purchases ON public.purchases (items_purchased);

-- Indexing a specific Key in the JSONB Column
CREATE INDEX idx_purchases_name ON public.purchases ((items_purchased ->> ‘name’));








----------------------------------------------- 
CREATE TABLE samples (
    id serial,
    sample jsonb
);

INSERT INTO samples (sample) VALUES (
 '{"result": [
     {"8410": "ABNDAT", "8411": "Abnahmedatum"},
     {"8410": "ABNZIT", "8411": "Abnahmezeit"},
     {"8410": "FERR_R", "8411": "Ferritin"}
  ]}'
);

SELECT 
    id, value 
FROM 
    samples s, jsonb_array_elements(s.sample#>'{result}') r  
WHERE 
    s.id = 26 and r->> '8410' = 'FERR_R';

-- id | value
----------------------------------------------
-- 26 | {"8410": "FERR_R", "8411": "Ferritin"}


SELECT 
    pos- 1 as elem_index
FROM 
    samples, 
    jsonb_array_elements(sample->'result') with ordinality arr(elem, pos)
WHERE
    id = 26 AND elem->> '8410' = 'FERR_R';

--  elem_index 
-- ------------
--           2

UPDATE 
    samples
SET
    sample = 
        jsonb_set(
          sample, 
          array['result', elem_index::text, 'ratingtext'], 
          '"some individual text"'::jsonb, 
          true
        )
FROM (
    SELECT 
        pos - 1 as elem_index
    FROM 
        samples, 
        jsonb_array_elements(sample->'result') with ordinality arr(elem, pos)
    WHERE
        id = 1 AND elem ->> '8410' = 'FERR_R'
    ) sub
WHERE id = 1;


SELECT id, jsonb_pretty(sample) FROM samples;

 -- id |                   jsonb_pretty                   
----+--------------------------------------------------
--  26 | {                                               +
--     |     "result": [                                 +
--     |         {                                       +
--     |             "8410": "ABNDAT",                   +
--     |             "8411": "Abnahmedatum"              +
--     |         },                                      +
--     |         {                                       +
--     |             "8410": "ABNZIT",                   +
--     |             "8411": "Abnahmezeit"               +
--     |         },                                      +
--     |         {                                       +
--     |             "8410": "FERR_R",                   +
--     |             "8411": "Ferritin",                 +
--     |             "ratingtext": "Some individual text"+
--     |         }                                       +
--     |     ]                                           +
--     | }
-- (1 row)
