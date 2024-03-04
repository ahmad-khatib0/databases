ALTER TABLE employees ADD manager_id uuid;

SELECT * FROM employees;

UPDATE employees e SET manager_id=(
  SELECT max(id) FROM employees e1 WHERE e1.city = e.city
); 

UPDATE employees e SET manager_id = (
  SELECT  id FROM employees e1 WHERE name='Jennifer Sanders' 
) WHERE name='Cindy Medina';

UPDATE employees e SET manager_id=NULL WHERE manager_id=id;

SELECT * FROM employees;

-- The RECURSIVE clause allows the Common Table Expression to refer to itself, poten‐
-- tially allowing for a query to return an arbitrarily high (or even infinite) set of results.
-- For instance, if the employees table contained a manager_id column that referred to
-- the manager’s row in the same table, then we could print a hierarchy of employees
-- and managers as follows:
WITH RECURSIVE employeeMgr AS (
  SELECT id,manager_id, name , NULL AS manager_name, 1 AS level
  FROM employees managers 
  WHERE manager_id IS NULL  
UNION ALL 
  SELECT subordinates.id,subordinates.manager_id, subordinates.name, managers.name ,managers.LEVEL+1
  FROM employeeMgr managers
  JOIN employees subordinates ON (subordinates.manager_id=managers.id)
)

SELECT * FROM employeeMgr ORDER BY level;
