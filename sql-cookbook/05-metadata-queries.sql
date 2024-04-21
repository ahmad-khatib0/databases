-- Listing Tables in a Schema
-- You want to see a list of all the tables you’ve created in a given schema.

-- DB2:  QuerySYSCAT.TABLES:
select tabname from syscat.tables
where tabschema = 'SMEAGOL'; 

-- Oracle: QuerySYS.ALL_TABLES:
select table_name from all_tables
where owner = 'SMEAGOL';

-- PostgreSQL, MySQL, and SQL Server:  Query INFORMATION_SCHEMA.TABLES:
select table_name from information_schema.tables 
where table_schema = 'SMEAGOL';




-- ###
-- Listing a Table’s Columns
-- You want to list the columns in a table, along with their data types,
-- and their position in the table they are in.

-- DB2:  QuerySYSCAT.COLUMNS:
select colname, typename, colno from syscat.columns 
where tabname = 'EMP' and tabschema = 'SMEAGOL'; 

-- Oracle:  QueryALL_TAB_COLUMNS:
select column_name, data_type, column_id from all_tab_columns
where owner = 'SMEAGOL' and table_name = 'EMP'; 

-- PostgreSQL, MySQL, and SQL Server:  Query INFORMATION_SCHEMA.COLUMNS:
select column_name, data_type, ordinal_position from information_schema.columns
where table_schema = 'SMEAGOL' and table_name = 'EMP'; 




-- ### Listing Indexed Columns for a Table 
-- list indexes, their columns, and the column position (if available) in the index for a given table.

-- DB2: QuerySYSCAT.INDEXES:
select a.tabname, b.indname, b.colname, b.colseq
from syscat.indexes a, syscat.indexcoluse b
where a.tabname = 'EMP'
      and a.tabschema = 'SMEAGOL'
      and a.indschema = b.indschema
      and a.indname = b.indname ; 

-- Oracle: QuerySYS.ALL_IND_COLUMNS:
select table_name, index_name, column_name, column_position from sys.all_ind_columns
where table_name = 'EMP' and table_owner = 'SMEAGOL'; 

-- PostgreSQL:  Query PG_CATALOG.PG_INDEXES and INFORMATION_SCHEMA.COLUMNS:
select a.tablename,a.indexname,b.column_name 
from pg_catalog.pg_indexes a , information_schema.columns b 
where a.schemaname = 'SMEAGOL' and a.tablename = b.table_name; 

-- MySQL: Use the SHOW INDEX command:
show index from emp; 

-- SQL Server: Query SYS.TABLES, SYS.INDEXES, SYS.INDEX_COLUMNS, and SYS.COLUMNS:
select a.name table_name, b.name index_name, d.name column_name, c.index_column_id
from sys.tables a, sys.indexes b, sys.index_columns c, sys.columns d
where a.object_id = b.object_id
      and b.object_id = c.object_id
      and b.index_id = c.index_id
      and c.object_id = d.object_id
      and c.column_id = d.column_id
      and a.name = 'EMP'; 



-- ###
-- Listing Constraints on a Table
-- list the constraints defined for a table in some schema and the columns they are defined on.

-- DB2:  Query SYSCAT.TABCONST and SYSCAT.COLUMNS:
select a.tabname, a.constname, b.colname, a.type 
from syscat.tabconst a, syscat.columns b
where a.tabname = 'EMP'
      and a.tabschema = 'SMEAGOL'
      and a.tabname = b.tabname
      and a.tabschema = b.tabschema; 

-- Oracle:  Query SYS.ALL_CONSTRAINTS and SYS.ALL_CONS_COLUMNS:
select a.table_name, a.constraint_name, b.column_name, a.constraint_type
from all_constraints a, all_cons_columns b
where a.table_name = 'EMP' 
and a.owner = 'SMEAGOL'
and a.table_name = b.table_name 
and a.owner = b.owner
and a.constraint_name = b.constraint_name; 

-- PostgreSQL, MySQL, and SQL Server: 
-- Query INFORMATION_SCHEMA.TABLE_CONSTRAINTS and INFORMATION_ SCHEMA.KEY_COLUMN_USAGE:
select a.table_name, a.constraint_name, b.column_name, a.constraint_type
from information_schema.table_constraints a, information_schema.key_column_usage b
where 
    a.table_name = 'EMP'
    and a.table_schema = 'SMEAGOL'
    and a.table_name   = b.table_name
    and a.table_schema = b.table_schema
    and a.constraint_name = b.constraint_name; 




-- ###
-- Listing Foreign Keys Without Corresponding Indexes
-- list tables that have foreign key columns that are not indexed. For example, 
-- you want to determine whether the foreign keys on table EMP are indexed.

-- DB2: Query SYSCAT.TABCONST, SYSCAT.KEYCOLUSE, SYSCAT.INDEXES, and SYSCAT.INDEXCOLUSE:
select fkeys.tabname, fkeys.constname, fkeys.colname, ind_cols.indname
from (
select a.tabschema, a.tabname, a.constname, b.colname
from syscat.tabconst a, syscat.keycoluse b
where 
   a.tabname = 'EMP'
and a.tabschema = 'SMEAGOL'
and a.type = 'F'
and a.tabname = b.tabname
and a.tabschema = b.tabschema
) fkeys

left join (
select a.tabschema, a.tabname, a.indname, b.colname
from syscat.indexes a, syscat.indexcoluse b
where a.indschema = b.indschema and a.indname = b.indname) ind_cols
on (
   fkeys.tabschema = ind_cols.tabschema
    and fkeys.tabname = ind_cols.tabname
    and fkeys.colname = ind_cols.colname 
)
where ind_cols.indname is null; 

-- Oracle: Query SYS.ALL_CONS_COLUMNS, SYS.ALL_CONSTRAINTS, and SYS.ALL_IND_COLUMNS:

SELECT a.table_name,
       a.constraint_name,
       a.column_name,
       c.index_name
FROM all_cons_columns a,
     all_constraints b,
     all_ind_columns c
WHERE a.table_name = 'EMP'
  AND a.owner = 'SMEAGOL'
  AND b.constraint_type = 'R'
  AND a.owner = b.owner
  AND a.table_name = b.table_name
  AND a.constraint_name = b.constraint_name
  AND a.owner = c.table_owner (+)
  AND a.table_name = c.table_name (+)
  AND a.column_name = c.column_name (+)
  AND c.index_name IS NULL; 

-- PostgreSQL
-- Query INFORMATION_SCHEMA.KEY_COLUMN_USAGE, INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS,
-- INFORMATION_SCHEMA.COL‐ UMNS, and PG_CATALOG.PG_INDEXES: 
SELECT fkeys.table_name,
       fkeys.constraint_name,
       fkeys.column_name,
       ind_cols.indexname
FROM
  (SELECT a.constraint_schema,
          a.table_name,
          a.constraint_name,
          a.column_name
   FROM information_schema.key_column_usage a,
        information_schema.referential_constraints b
   WHERE a.constraint_name = b.constraint_name
     AND a.constraint_schema = b.constraint_schema
     AND a.constraint_schema = 'SMEAGOL'
     AND a.table_name = 'EMP' ) fkeys
LEFT JOIN
  (SELECT a.schemaname,
          a.tablename,
          a.indexname,
          b.column_name
   FROM pg_catalog.pg_indexes a,
        information_schema.columns b
   WHERE a.tablename = b.table_name 
        AND a.schemaname = b.table_schema 
  ) ind_cols ON ( 
                  fkeys.constraint_schema = ind_cols.schemaname
                  AND fkeys.table_name = ind_cols.tablename
                  AND fkeys.column_name = ind_cols.column_name
                )
WHERE ind_cols.indexname IS NULL; 

-- SQL Server:  Query SYS.TABLES, SYS.FOREIGN_KEYS, SYS.COLUMNS, SYS.INDEXES, and SYS.INDEX_COLUMNS:
 SELECT fkeys.table_name, fkeys.constraint_name, fkeys.column_name, ind_cols.index_name
FROM
  (SELECT a.object_id, d.column_id, a.name TABLE_NAME, b.name CONSTRAINT_NAME, d.name COLUMN_NAME
   FROM sys.tables a
   JOIN sys.foreign_keys b ON ( a.name = 'EMP' AND a.object_id = b.parent_object_id)
   JOIN sys.foreign_key_columns c ON (b.object_id = c.constraint_object_id)
   JOIN sys.columns d ON (c.constraint_column_id = d.column_id AND a.object_id = d.object_id)
  ) fkeys
LEFT JOIN
  (SELECT a.name index_name,
          b.object_id,
          b.column_id
   FROM sys.indexes a, sys.index_columns b
   WHERE a.index_id = b.index_id 
  ) ind_cols ON (
                 fkeys.object_id = ind_cols.object_id
                 AND fkeys.column_id = ind_cols.column_id
                )
WHERE ind_cols.index_name IS NULL; 







-- ### 
-- Using SQL to Generate SQL

-- You want to create dynamic SQL statements, perhaps to automate maintenance tasks. You want to 
-- accomplish three tasks in particular: count the number of rows in your tables, disable foreign 
-- key constraints defined on your tables, and generate insert scripts from the data in your tables.

-- /* generate SQL to count all the rows in all your tables */
select 'select count(*) from '||table_name||';' cnts from user_tables;
-- ⬇️⬇️⬇️⬇️⬇️⬇️⬇️
-- CNTS
-- --------------------------------
-- select count(*) from ANT;
-- select count(*) from BONUS;
-- select count(*) from DEMO1;
-- ................... etc 

-- /* disable foreign keys from all tables */
select 'alter table '||table_name|| ' disable constraint '||constraint_name||';' cons
from user_constraints
where constraint_type = 'R';
-- ⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️
-- CONS
------------------------------------------------
-- alter table ANT disable constraint ANT_FK;
-- alter table BONUS disable constraint BONUS_FK;
-- alter table DEMO1 disable constraint DEMO1_FK;
-- ................... etc


-- /* generate an insert script from some columns in table EMP */
select 'insert into emp(empno,ename,hiredate) ' || 
         chr(10) || 
        'values( '||empno||','||''''||ename ||''' ,to_date('||''''||hiredate||''') );' 
inserts from emp
where deptno = 10;
-- ⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️
-- INSERTS
--------------------------------------------------
-- insert into emp(empno,ename,hiredate)
-- values( 7782,'CLARK',to_date('09-JUN-2006 00:00:00') );
-- ................... etc




-- ###
-- Describing the Data Dictionary Views in an Oracle Database
-- You are using Oracle. You can’t remember what data dictionary views are available to you, nor can 
-- you remember their column definitions. Worse yet, you do not have convenient access to vendor documentation.

-- Query the view named DICTIONARY to list data dictionary views and their purposes:
select table_name, comments from dictionary order by table_name;



