-- Stacking One Rowset atop Another

-- For example, you want to display the name and department number of the employees in department 10 
-- in table EMP, along with the name and department number of each department in table DEPT

SELECT ename as ename_and_dname deptno FROM emp 
where deptno = 10 
union all 
select '----------', null from t1 
union all 
select dname, deptno from dept;

-- ENAME_AND_DNAME  DEPTNO
-- ---------------  ----------
-- CLARK  10
-- KING   10
-- MILLER 10
-- ----------
-- ACCOUNTING 10
-- RESEARCH   20
-- SALES      30
-- OPERATIONS 40 


-- Using UNION is roughly equivalent to the following query, which applies DISTINCT
-- to the output from a UNION ALL
select distinct deptno from (
  select deptno from emp 
  union all 
  select deptno from dept
)


-- Combining Related Rows

--  A join is an operation that combines rows from two tables into one. An equi-join is one in 
-- which the join condition is based on an equality condition (e.g., where one department number equals another).

-- an equi-join, which is a type of inner join
SELECT e.ename , d.loc from emp e,  dept d 
where e.deptno = d.deptno and e.deptno = 10;


select e.ename, d.loc, e.deptno as emp_deptno, d.deptno as dept_deptno
from emp e, dept d 
where e.deptno = d.deptno and  e.deptno = 10; 

-- An alternative solution makes use of an explicit JOIN clause (the INNER keyword is optional):
SELECT e.ename , d.loc  FROM emp 
inner join dept d on (e.deptno = d.deptno)
where e.deptno = 10;




-- Finding Rows in Common Between Two Tables
create view V as 
SELECT ename,job, sal  FROM emp where job = 'CLERK'; -- this only shows CLERK jobs 

-- MySQL and SQL Server
-- Join table EMP to view V using multiple join conditions:
select e.empno,e.ename,e.job,e.sal,e.deptno from emp e, V 
where e.ename = v.ename and and e.job = v.job and e.sal = v.sal ; 

-- Alternatively, you can perform the same join via the JOIN clause:
select e.empno,e.ename,e.job,e.sal,e.deptno from emp e 
join V on (
      e.ename = v.ename
      and e.job = v.job
      and e.sal = v.sal 
    );


-- DB2, Oracle, and PostgreSQL
-- (INTERSECT will return rows common to both row sources)
select empno,ename,job,sal,deptno from emp 
where (ename, job, sal) in (
  select ename,job,sal from emp
  intersect 
  select ename,job,sal from V
);


-- ###
-- Retrieving Values from One Table That Do Not Exist in Another

-- DB2, PostgreSQL, and SQL Server
-- ═════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
-- (EXCEPT operator takes the first result set and removes from it all rows found in the second result set) 
-- (The EXCEPT operator will return rows from the upper query (the query before the EXCEPT)                 
-- that do not exist in the lower query (the query after the EXCEPT).)                                      
-- ═════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
select deptno from dept
except 
select deptno from emp; 

-- Oracle
select deptno from dept
minus
select deptno from emp; 

-- MySQL
SELECT distinct deptno FROM dept 
where deptno not in (select deptno from emp);

-- To avoid the problem with NOT IN and NULLs, use a correlated subquery in conjunction with NOT EXISTS.
SELECT d.deptno FROM dept d
where not exists (
  select 1 from emp e where d.deptno = e.deptno
);



-- ###
-- Retrieving Rows from One Table That Do Not Correspond to Rows in Another

-- DB2, MySQL, PostgreSQL, and SQL Server
-- Use an outer join and filter for NULLs (keyword OUTER is optional):
SELECT d.*  FROM dept d left outer join emp e 
on (d.deptno = e.deptno)
where e.deptno is null;

-- This solution works by outer joining and then keeping only rows that have no match.
-- This sort of operation is sometimes called an anti-join
select e.ename, e.deptno as emp_deptno, d.* from dept d 
left join emp e on (d.deptno = e.deptno); 



-- ###
-- Adding Joins to a Query Without Interfering with Other Joins

-- You can use an outer join to obtain the additional information without losing the data
-- from the original query. (e.g  not every employee has a bonus) 
select e.ename, d.loc, eb.received from emp e 
join dept d on (e.deptno = d.deptno)
left join emp_bonus eb  on (e.empno = eb.empno)
order by 2

-- You can also use a scalar subquery (a subquery placed in the SELECT list) to mimic an outer join:
 select e.ename, d.loc, (
  select eb.received from emp_bonus eb where eb.empno = e.empno
) as received 
from emp e , dept d where e.deptno = d.deptno
order by 2; 



-- ###
--  Determining Whether Two Tables Have the Same Data

create view V
as
select * from emp where deptno != 10
union all
select * from emp where ename = 'WARD'; 

-- You want to determine whether this view has exactly the same data as table EMP
-- the solution will reveal not only different data but duplicates as well.

-- DB2 and PostgreSQL 
-- Use the set operations EXCEPT and UNION ALL to find the difference between view
-- V and table EMP combined with the difference between table EMP and view V:
(
  select empno,ename,job,mgr,hiredate,sal,comm,deptno, count(*) as cnt
  from V 
  group by empno,ename,job,mgr,hiredate,sal,comm,deptno
  except 
  select empno,ename,job,mgr,hiredate,sal,comm,deptno, count(*) as cnt 
  from emp
  group by empno,ename,job,mgr,hiredate,sal,comm,deptno
)
-- ⬆️⬆️⬆️⬆️⬆️⬆️⬆️⬆️ The result set represents a row found in view V that is either not in 
-- table EMP, or has a different cardinality than that same row in table EMP

--does the opposite of the query The query returns rows in table EMP not in view V:
-- ⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️
union all 
(
  select empno,ename,job,mgr,hiredate,sal,comm,deptno, count(* )as cnt 
  from emp 
  group by empno,ename,job,mgr,hiredate,sal,comm,deptno
  except 
  select empno,ename,job,mgr,hiredate,sal,comm,deptno, count(*) as cnt 
  from V
  group by empno,ename,job,mgr,hiredate,sal,comm,deptno
);

-- Oracle
-- Use the set operations MINUS and UNION ALL to find the difference between view
-- V and table EMP combined with the difference between table EMP and view V: 
-- (only replace EXCEPT with MINUS)  

-- MySQL and SQL Server
-- Use a correlated subquery and UNION ALL to find the rows in view V and not in
-- table EMP combined with the rows in table EMP and not in view V:
select * from (
   select e.empno,e.ename,e.job,e.mgr,e.hiredate, e.sal,e.comm,e.deptno, count(*) as cnt
   from emp e
   group by empno,ename,job,mgr,hiredate, sal,comm,deptno 
  ) e 
  where not exits (
    select null from (
       select v.empno,v.ename,v.job,v.mgr,v.hiredate, v.sal,v.comm,v.deptno, count(*) as cnt
       from v 
       group by empno,ename,job,mgr,hiredate, sal,comm,deptno
    ) v 
   where v.empno = e.empno
   and v.ename = e.ename
   and v.job = e.job
   and coalesce(v.mgr,0) = coalesce(e.mgr,0)
   and v.hiredate = e.hiredate
   and v.sal = e.sal
   and v.deptno = e.deptno
   and v.cnt = e.cnt
   and coalesce(v.comm,0) = coalesce(e.comm,0)
)

union all

SELECT * FROM (
      v.empno, v.ename, v.job, v.mgr, v.hiredate, v.sal, v.comm, v.deptno, count(*) AS cnt
      FROM v
      GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
  ) v
WHERE NOT EXISTS (
    SELECT NULL FROM (
    SELECT e.empno, e.ename, e.job, e.mgr, e.hiredate, e.sal, e.comm, e.deptno, count(*) AS cnt
    FROM emp e
    GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
  ) e
   WHERE v.empno = e.empno
   AND v.ename = e.ename
   AND v.job = e.job
   AND coalesce(v.mgr, 0) = coalesce(e.mgr, 0)
   AND v.hiredate = e.hiredate
   AND v.sal = e.sal
   AND v.deptno = e.deptno
   AND v.cnt = e.cnt
   AND coalesce(v.comm, 0) = coalesce(e.comm, 0) 
); 



-- ### 
-- Performing Joins When Using Aggregates Problem

-- You want to perform an aggregation, but your query involves multiple tables. You want to ensure 
-- that joins do not disrupt the aggregation. For example, you want to find the sum of the salaries 
-- for employees in department 10 along with the sum of their bonuses. Some employees have more 
-- than one bonus, and the join between table EMP and table EMP_BONUS is causing incorrect values 
-- to be returned by the aggregate function SUM. 

-- MySQL and PostgreSQL
SELECT d.deptno,
       d.total_sal,
       sum(e.sal*CASE
                     WHEN eb.type = 1 then .1
                     WHEN eb.type = 2 then .2 else .3
                 END
          ) AS total_bonus
FROM emp e, emp_bonus eb,
  (SELECT deptno, sum(sal) AS total_sal
   FROM emp
   WHERE deptno = 10
   GROUP BY deptno
  ) d
  
WHERE e.deptno = d.deptno
  AND e.empno  = eb.empno
GROUP BY d.deptno, d.total_sal; 


-- DB2, Oracle, and SQL Server
-- These platforms support the preceding solution, but they also support an alternative
-- solution using the window function SUM OVER:
SELECT DISTINCT deptno, total_sal, total_bonus
FROM
  (SELECT e.empno,
          e.ename,
          sum(DISTINCT e.sal) OVER (PARTITION BY e.deptno) AS total_sal,
         e.deptno,
         sum(e.sal * CASE
                         WHEN eb.type = 1 then .1
                         WHEN eb.type = 2 then .2 else .3
                     END) OVER (PARTITION BY deptno) AS total_bonus
   FROM emp e,
        emp_bonus eb
   WHERE e.empno = eb.empno
     AND e.deptno = 10 
  ) x;
  
-- ╔═════════════════════════════════════════════════════════════════════════════════════════╗
-- ║ The windowing function, SUM OVER, is called twice, first to compute the sum of the      ║
-- ║ distinct salaries for the defined partition or group. In this case, the partition is    ║
-- ║ DEPTNO 10, and the sum of the distinct salaries for DEPTNO 10 is 8750. The next call to ║
-- ║ SUM OVER computes the sum of the bonuses for the same defined partition. The final result║
-- ║ set is produced by taking the distinct values for TOTAL_SAL, DEPTNO, and TOTAL_BONUS.   ║
-- ╚═════════════════════════════════════════════════════════════════════════════════════════╝




-- ####
-- Performing Outer Joins When Using Aggregates Problem

-- find both the sum of all salaries for department 10 and the sum 
-- of all bonuses for all employees in department 10

-- DB2, MySQL, PostgreSQL, and SQL Server
SELECT deptno,
       sum(DISTINCT sal) AS total_sal,
       sum(bonus) AS total_bonus
FROM
  (SELECT e.empno,
          e.ename,
          e.sal,
          e.deptno,
          e.sal*CASE
                    WHEN eb.type IS NULL THEN 0
                    WHEN eb.type = 1 then .1
                    WHEN eb.type = 2 then .2 else .3
                END AS bonus
   FROM emp e
   LEFT OUTER JOIN emp_bonus eb ON (e.empno = eb.empno)
   WHERE e.deptno = 10 
  )
GROUP BY deptno; 

-- use the window function SUM OVER:
SELECT DISTINCT deptno, total_sal, total_bonus
FROM
  (SELECT e.empno,
          e.ename,
          sum(DISTINCT e.sal) OVER (PARTITION BY e.deptno) AS total_sal,
          e.deptno,
          sum(e.sal*CASE
                         WHEN eb.type IS NULL THEN 0
                         WHEN eb.type = 1 then .1
                         WHEN eb.type = 2 then .2 else .3
                     END
              ) OVER (PARTITION BY deptno) AS total_bonus
   FROM emp e
   LEFT OUTER JOIN emp_bonus eb ON (e.empno = eb.empno)
   WHERE e.deptno = 10 
  ) x;

  
-- .
SELECT d.deptno,
       d.total_sal,
       sum(e.sal*CASE
                     WHEN eb.type = 1 then .1
                     WHEN eb.type = 2 then .2 else .3
                 END) AS total_bonus
FROM emp e, emp_bonus eb,
  (SELECT deptno, sum(sal) AS total_sal
   FROM emp
   WHERE deptno = 10
   GROUP BY deptno
  ) d
WHERE e.deptno = d.deptno AND e.empno = eb.empno
GROUP BY d.deptno, d.total_sal; 



-- ###
-- Returning Missing Data from Multiple Tables
-- You want to return missing data from multiple tables simultaneously. Returning rows
-- from table DEPT that do not exist in table EMP (any departments that have no employees)

-- DB2, MySQL, PostgreSQL, and SQL Server
-- Use the explicit FULL OUTER JOIN command to return missing rows from both
-- tables along with matching rows:
SELECT  d.deptno,d.dname,e.ename  FROM dept d 
full outer join emp e on (d.deptno=e.deptno);

-- Alternatively, since MySQL does not yet have a FULL OUTER JOIN, UNION the
-- results of the two different outer joins:
SELECT d.deptno, d.dname, e.ename FROM dept d
RIGHT OUTER JOIN emp e ON (d.deptno=e.deptno)
UNION
SELECT d.deptno, d.dname, e.ename FROM dept d
LEFT OUTER JOIN emp e ON (d.deptno=e.deptno);

-- Oracle
select d.deptno,d.dname,e.ename from dept d, emp e
where d.deptno = e.deptno(+)
union
select d.deptno,d.dname,e.ename from dept d, emp e
where d.deptno(+) = e.deptno; 





-- ###
-- Using NULLs in Operations and Comparisons
-- NULL is never equal to or not equal to any value, not even itself,

-- find all employees in EMP whose commission (COMM) is less than the commission of 
-- employee WARD. Employees with a NULL commission should be included as well.
SELECT ename, comm  FROM emp 
where coalesce(comm , 0 ) < (
  select comm from emp where ename = 'WARD'
);
