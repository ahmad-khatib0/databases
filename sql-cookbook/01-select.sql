-- ### 
-- attempt to reference alias names in the WHERE clause fails:
SELECT sal as salary, com as commission  FROM emp
WHERE salary > 5000;

-- Solution By wrapping your query as an inline view, you can reference the aliased column
SELECT * FROM  (
  SELECT sal as salary, com as commission  FROM emp
) x 
WHERE salary > 5000;

--╔═════════════════════════════════════════════════════════════════════════════════╗
--║ -- (The inline view in this solution is aliased X. Not all databases require an ║
--║ -- inline view to be explicitly aliased, but some do. All of them accept it.)   ║
--╚═════════════════════════════════════════════════════════════════════════════════╝



-- ### 
-- DB2, Oracle, PostgreSQL:  These databases use the double vertical bar as the concatenation operator:
SELECT ename || ' works as a ' || job FROM emp ;

-- MYSQL: This database supports a function called CONCAT:
select concat(ename, ' WORKS AS A ',job) as msg from emp where deptno=10; 

-- SQL Server: Use the + operator for concatenation :
select ename + ' WORKS AS A ' + job as msg  from emp where deptno = 10;


--- ### 
-- limit the number of rows
-- DB2:  In DB2 use the FETCH FIRST clause:
SELECT * FROM emp fetch first 5 rows only;

-- MySQL and PostgreSQL
select * from emp limit 5; 

-- Oracle: place a restriction on the number of rows returned by restricting ROWNUM
select * from emp where rownum <= 5; 

-- SQL Server: 
select top 5 * from emp ; 


-- ###
-- Returning n Random Records from a Table
-- DB2: Use the built-in function RAND in conjunction with ORDER BY and FETCH
SELECT ename, job FROM emp ORDER BY rand() fetch first 5 only;

-- MySQL: Use the built-in RAND function in conjunction with LIMIT and ORDER BY
SELECT ename, job  FROM emp order by rand() limit 5;

-- PostgreSQL: Use the built-in RANDOM function in conjunction with LIMIT and ORDER BY:
SELECT ename, job FROM emp order by random() limit 5;

-- Oracle: 
select * from (
  SELECT ename, job FROM emp ORDER BY dbms_random.value()
) WHERE rownum 5; 

-- SQL Server:
select top 5 ename,job from emp order by newid();

