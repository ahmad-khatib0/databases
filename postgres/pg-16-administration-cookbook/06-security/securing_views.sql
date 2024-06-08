
-- Securing views
-- It is a common technique to use a view to disclose only some parts of a secret table; however, a
-- clever attacker can use access to the view to display the rest of the table using log messages. For
-- instance, consider the following example:

CREATE VIEW for_the_public AS
SELECT * FROM reserved_data WHERE importance < 10;

GRANT SELECT ON for_the_public TO PUBLIC;

-- A malicious user could define the following function:
CREATE FUNCTION f(text)
RETURNS boolean
COST 0.00000001
LANGUAGE plpgsql AS $$
BEGIN
  RAISE INFO '$1: %', $1;
  RETURN true;
END;
$$; 

-- So They could use it to filter rows from the view:
SELECT * FROM for_the_public x WHERE f(x :: text);

-- The PostgreSQL optimizer will then internally rearrange the query, expanding the definition of
-- the view and then combining the two filter conditions into a single WHERE clause. The trick here
-- is that the function has been told to be very cheap using the COST keyword, so the optimizer will
-- choose to evaluate that condition first. In other words, the function will access all of the rows
-- in the table, as you will realize when you see the corresponding INFO lines on the console if you
-- run the code yourself.

-- This security leak can be prevented using the security_barrier attribute:
ALTER VIEW for_the_public SET (security_barrier = on);

-- This means that the conditions that define the view will always be computed first, 
-- IRRESPECTIVE OF COST CONSIDERATIONS.

-- The performance impact of this fix can be mitigated by the LEAKPROOF attribute for functions.
-- In short, a function that cannot leak information other than its output value can be marked as
-- LEAKPROOF by a superuser, ensuring that the planner will know it’s secure enough to compute
-- the function before the other view conditions.




