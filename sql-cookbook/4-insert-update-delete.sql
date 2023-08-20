
-- the tow are valid 
insert into D values (default); 
insert into D (id) values(default); 

--###
-- Copying Rows from One Table into Another
insert into dept_east (deptno,dname,loc)
select deptno,dname,loc from dept
where loc in ( 'NEW YORK','BOSTON' ); 



-- ###
-- Copying a Table Definition
-- You want to create a new table having the same set of columns as an existing table.

-- DB2
create table dept_2 like dept; 

-- Oracle, MySQL, and PostgreSQL
create table dept_2 as 
select * from dept where 1 = 0;

-- SQL Server
select * into dept_2 from dept 
where 1 = 0 ; 





-- ###
-- Inserting into Multiple Tables at Once

-- Oracle
insert all 
when loc in ('NEW YORK','BOSTON') then
     into dept_east (deptno,dname,loc) values (deptno,dname,loc)
when loc = 'CHICAGO' then
     into dept_mid (deptno,dname,loc) values (deptno,dname,loc)
else 
     into dept_west (deptno,dname,loc) values (deptno,dname,loc)
select deptno,dname,loc from dept ;

-- DB2
CREATE TABLE dept_east (
  deptno integer, 
  dname varchar(10),
  loc varchar(10) CHECK (loc in ('NEW YORK', 'BOSTON'))
); 

CREATE TABLE dept_mid (
  deptno integer, 
  dname varchar(10), 
  loc varchar(10) CHECK (loc = 'CHICAGO')
); 

CREATE TABLE dept_west (
  deptno integer, 
  dname varchar(10), 
  loc varchar(10) CHECK (loc = 'DALLAS')
); 

INSERT INTO
  (
   SELECT * FROM dept_west 
   UNION ALL 
   SELECT * FROM dept_east
   UNION ALL 
   SELECT * FROM dept_mid
)
SELECT * FROM dept; 





-- ###
-- Blocking Inserts to Certain Columns (View insertion)
-- You want to prevent users from inserting values into certain table columns.

-- Create a view on the table exposing only those columns you want to expose. 
-- Then force all inserts to go through that view.
create view new_emps as 
select empno, ename, job from emp ; 
-- then Grant access to this view to those users and programs allowed to populate only the three 
-- fields in the view When you insert into a simple view such as in the solution, your database 
-- server will translate that insert into the underlying table. For example, the following insert:
insert into new_emps (empno ename, job) values (1, 'Jonathan', 'Editor'); 
-- will be translated behind the scenes into:
insert into emp (empno ename, job) values (1, 'Jonathan', 'Editor'); 




-- ###
-- Updating When Corresponding Rows Exist
-- You want to update rows in one table when corresponding rows exist in another
UPDATE emp  SET sal = sal * 1.20  
WHERE empno IN ( select  empno from emp_bonus );

-- Alternatively, you can use EXISTS instead of IN:
-- ( NULL does not have an adverse effect on the update.)
update emp set sal = sal * 1.20 
where exists (
  select null from emp_bonus where emp.empno = emp_bonus.empno
); 





-- ###
-- Updating with Values from Another Table
-- You want to update the salaries and commission of certain employees in table EMP 
-- using values table NEW_SAL if there is a match between EMP.DEPTNO and NEW_SAL.DEPTNO, 
-- update EMP.SAL to NEW_SAL.SAL, and update EMP.COMM to 50% of NEW_SAL.SAL. 

-- DB2
UPDATE emp e SET (e.sal, e.comm) =
  (
   SELECT ns.sal, ns.sal/2 FROM new_sal ns
   WHERE ns.deptno = e.deptno
  )
WHERE EXISTS(
     SELECT * FROM new_sal ns
     WHERE ns.deptno = e.deptno 
  ); 


-- MySQL
update emp e, new_sal ns set e.sal=ns.sal, e.comm=ns.sal/2
where e.deptno=ns.deptno; 

-- Oracle:
-- The method for the DB2 solution will work for Oracle,
-- but as an alternative, you can update an inline view:
update (
  select e.sal as emp_sal, e.comm as emp_comm, ns.sal as ns_sal, ns.sal/2 as ns_comm
  from emp e, new_sal ns
  where e.deptno = ns.deptno
) set emp_sal = ns_sal, emp_comm = ns_comm; 

-- PostgreSQL
update emp set sal = ns.sal, comm = ns.sal/2 
FROM new_sal ns
where ns.deptno = emp.deptno; 


-- SQL Server
update e set e.sal = ns.sal, e.comm = ns.sal/2
from emp e, new_sal ns
where ns.deptno = e.deptno; 




-- ### 
-- Merging Records
-- You want to conditionally insert, update, or delete records in a table depending on
-- whether corresponding records exist. (If a record exists, then update; if not, then
-- insert; if after updating a row fails to meet a certain condition, delete it.) 

-- The statement designed to solve this problem is the MERGE statement, and it can
-- perform either an UPDATE or an INSERT, (Currently, MySQL does not have a MERGE statement)

-- • If any employee in EMP_COMMISSION also exists in table EMP, 
--    then update their commission (COMM) to 1000.
-- • For all employees who will potentially have their COMM updated to 1000, if their
--    SAL is less than 2000, delete them (they should not be exist in EMP_[.keep together] COMMISSION).
-- • Otherwise, insert the EMPNO, ENAME, and DEPTNO values from table EMP into table EMP_COMMISSION.

merge into emp_commission ec
using (select * from emp ) emp on (ec.empno = emp.empno) 
-- When the join succeeds, the two rows are considered “matched,”
when matched then 
  update set ec.comm = 2000 
  delete where (sal < 2000)
when not matched then 
  insert (ec.empno,ec.ename,ec.deptno,ec.comm)
  values (emp.empno,emp.ename,emp.deptno,emp.comm);




-- Deleting Referential Integrity Violations
-- delete records from a table when those records refer to nonexistent records in some other table

-- some employees are assigned to departments that do not exist. You want to delete those employees.
DELETE FROM emp WHERE not exists (
  select * from dept where dept.deptno = emp.deptno
) ;




-- ###
-- Deleting Duplicate Records
DELETE FROM dupes WHERE id not in (
  select min (id) from dupes group by name
);

-- For MySQL users you will need slightly different syntax because 
-- you cannot reference the same table twice in a delete
DELETE FROM dupes WHERE id not in (
  SELECT min(id) FROM 
     (select id, name from dupes) tmp
     group by name
);





-- ###
-- Deleting Records Referenced from Another Table

-- delete from EMP the records for those employees working at a department that has three or more accidents.
DELETE FROM emp WHERE deptno in (
   select deptno from dept_accidents 
   group by deptno
   hanving count(*) >= 3
);
