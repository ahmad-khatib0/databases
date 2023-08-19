select ename, job, sal from emp where deptno = 10 order by sal asc;

select ename, job, sal from emp where deptno = 10 order by sal desc; 

select empno, deptno, sal, ename, job FROM emp ORDER BY deptno, sal DESC; 


-- ### Sorting by Substrings:
-- DB2, MySQL, Oracle, and PostgreSQL
SELECT ename, job FROM emp ORDER by substr(job, length(job) -1);

-- SQL Server: Use the SUBSTRING function in the ORDER BY clause:
SELECT ename, job  FROM emp order by substring(job, len(job) - 1, 2);



-- ###
-- Sorting Mixed Alphanumeric Data
create view V as SELECT ename || ' ' || deptno as data FROM emp;

SELECT * FROM V ;

--  sort the results by DEPTNO or ENAME

-- Oracle, SQL Server, and PostgreSQL: Use the functions REPLACE and TRANSLATE to modify the string for sorting:
/* ORDER BY ENAME */
SELECT data  FROM V order BY REPLACE(
  data, replace( translate(data, '0123456789' , '##########'), '#', '' ), ''
);

/* ORDER BY ENAME */
SELECT data  FROM V order by replace(
  translate(data, '0123456789' , '##########'), ''
);

-- DB2
/* ORDER BY DEPTNO */
SELECT *  FROM (
  SELECT ename || ' ' || cast(deptno as char(2 )) as data  FROM emp;
) v 
order by replace(data, replace(translate(data,'##########','0123456789'),'#',''),'');

/* ORDER BY ENAME */
select * from (
   select ename||' '||cast(deptno as char(2)) as data from emp
) v
order by replace( translate(data,'##########','0123456789'),'#',''); 


-- finally sort by ENAME and DEPTNO
SELECT data,
       replace(data, replace(translate(data, '0123456789', '##########'), '#', ''), ''),
       nums,
       replace(translate(data, '0123456789', '##########'), '#', '') chars 
FROM V;



-- ╔═══════════════════════════════╗
-- ║ example on translate function ║
-- ╚═══════════════════════════════╝
SELECT TRANSLATE('12345', '134', 'ax'); -- => a2x5 , 
-- Because the string '134' has more characters than the string 'ax', the TRANSLATE() function 
-- removes the extra character in the string '134', which is '4', from the string '12345'.



-- ### 
-- Dealing with Nulls When Sorting

-- Use a CASE expression to “flag” when a value is NULL

-- DB2, MySQL, PostgreSQL, and SQL Server
/* NON-NULL COMM SORTED ASCENDING, ALL NULLS LAST */
SELECT ename, sal, comm  FROM (
  select ename, sal, comm, 
  case when comm is null then 0 else 1 end as is_null
  from exp
) x 
order by is_null desc , comm;

/* NON-NULL COMM SORTED DESCENDING, ALL NULLS LAST */
order by is_null desc , comm desc;

/* NON-NULL COMM SORTED ASCENDING, ALL NULLS FIRST */
order by is_null,comm; 

/* NON-NULL COMM SORTED DESCENDING, ALL NULLS FIRST */
order by is_null,comm desc; 


-- Oracle
-- /* NON-NULL COMM SORTED ASCENDING, ALL NULLS LAST */
SELECT ename, sal, comm  FROM emp order by comm nulls last;

/* NON-NULL COMM SORTED ASCENDING, ALL NULLS FIRST */
order by comm nulls first;

/* NON-NULL COMM SORTED DESCENDING, ALL NULLS FIRST */ 
order by comm desc nulls first; 



-- ###
-- Sorting on a Data-Dependent Key

-- if JOB is SALES‐MAN, you want to sort on COMM; otherwise, you want to sort by SAL
-- Use a CASE expression in the ORDER BY clause:
SELECT ename, sal, job, comm  FROM emp 
order by case when job = 'SALESMAN' then comm else sal end;

-- You can use the CASE expression to dynamically change how results are sorted

SELECT ename, sal, job, comm, 
case when job = 'SALESMAN' then comm else sal end as ordered 
FROM emp order by 5; 
