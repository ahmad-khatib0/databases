
-- Walking a String

-- traverse a string to return each character as a row, (for the ename = 'KING') 
SELECT substr(e.ename, iter.pos, 1) AS C
FROM
  (SELECT ename FROM emp WHERE ename = 'KING') e,
  (SELECT id AS pos FROM t10) iter -- it is common practice to refer to table t10 as a “pivot” table.
WHERE iter.pos <= length(e.ename);


-- To restrict the result set to the same number of rows as there are characters in the name
select ename, iter.pos
from (select ename from emp where ename = 'KING') e,
(select id as pos from t10) iter
where iter.pos <= length(e.ename);


SELECT substr(e.ename, iter.pos ) a,  
       substr(e.ename, length(e.ename) - iter.pos + 1 ) b 
    from (select ename from emp where ename = 'KING' ) e,
       (select id pos from t10 ) iter
    where iter.pos <= length (e.ename);
  


--
-- ### Embedding Quotes Within String Literals
select 'g''day mate' qmarks from t1 union all 
select 'beavers''    teeth' from t1 union all 
select ''''                 from t1 ;  

select '''' as quote        from t1;


-- 
-- ### Counting the Occurrences of a Character in a String
-- determine how many commas are in the string.

select (
  length('10,CLARK,MANAGER') - length(replace('10,CLARK,MANAGER', ',', ''))
) / length(',') as cnt from t1; 

-- NOTE: occurrence of “LL” in the string “HELLO HELLO” without dividing will return an incorrect result:

select (
   length('HELLO HELLO')- length(replace('HELLO HELLO','LL','')))/length('LL') as correct_cnt,
  (length('HELLO HELLO')- length(replace('HELLO HELLO','LL',''))) as incorrect_cnt
from t1; 


-- ### Removing Unwanted Characters from a String

-- DB2, Oracle, PostgreSQL, and SQL Server 
select ename,
    replace(translate(ename, 'aaaaa','AEIOU' ),'a','' ) as stripped1, sal, 
    replace(cast( sal as char(4)), '0', '' )            as stripped2
from emp;

-- MySQL
select ename,
  replace( replace( replace( replace( replace(ename,'A',''),'E',''),'I',''),'O',''),'U','') as stripped1,
  sal,
  replace(sal,0,'') stripped2
from emp; 


-- ###
-- Separating Numeric and Character Data

-- DB2:  Use the functions TRANSLATE and REPLACE to isolate and separate the numeric from the character data:
select replace(
  translate(data,'0000000000','0123456789'),'0','') ename,
  cast( replace( translate( lower(data), repeat('z',26), 'abcdefghijklmnopqrstuvwxyz'),'z','') as integer) sal
from (
  select ename||cast(sal as char(4)) data from emp
) x;

-- Oracle
select replace(
 translate(data,'0123456789','0000000000'),'0') ename, 
 to_number( replace( translate(lower(data), 'abcdefghijklmnopqrstuvwxyz', rpad('z',26,'z') ),'z')) sal
from (
 select ename||sal data from emp
);


-- PostgreSQL
select replace(
   translate( data, '0123456789', '0000000000'), '0', '') as ename,
   cast( replace( translate(lower(data), 'abcdefghijklmnopqrstuvwxyz', rpad('z',26,'z')),'z','') as integer) as sal
from (
   select ename||sal as data from emp
) x; 

-- SQL Server 
select replace(
   translate(data,'0123456789','0000000000'),'0','') as ename,
   cast( replace( translate(lower(data), 'abcdefghijklmnopqrstuvwxyz', replicate('z',26),'z','') as integer) as sal
from (
   select concat(ename,sal) as data from emp
) x; 



create view V as
  select ename as data from emp where deptno=10
    union all
  select ename||', $'|| cast(sal as char(4)) ||'.00' as data from emp where deptno=20
    union all
  select ename|| cast(deptno as char(4)) as data from emp where deptno=30; 


-- ###
--  Determining Whether a String Is Alphanumeric
-- DB2 
select data from V
where translate( lower(data), repeat('a',36), '0123456789abcdefghijklmnopqrstuvwxyz') 
           = 
          repeat('a', length(data) ); 


-- MySQL 
select data from V where data regexp '[^0-9a-zA-Z]' = 0 ;

-- Oracle and PostgreSQL
select data from V  where 
  translate(lower(data), '0123456789abcdefghijklmnopqrstuvwxyz', rpad('a',36,'a')) = 
rpad('a',length(data),'a'); 

-- sql Server 
select data from V where 
   translate(lower(data), '0123456789abcdefghijklmnopqrstuvwxyz', replicate('a',36)) 
   = replicate('a',len(data)) ; 


-- DB2, Oracle, PostgreSQL, and SQL Server
-- To find the rows that are alphanumeric only,
select data, 
  translate(lower(data), '0123456789abcdefghijklmnopqrstuvwxyz', rpad('a',36,'a')) translated,
  rpad('a',length(data),'a') fixed
from V; 

-- MySQL The expression in the WHERE clause:
where data regexp '[^0-9a-zA-Z]' = 0; 



-- ###
-- Extracting Initials from a Name

-- DB2
select replace(
 replace( 
    translate (
       replace ('Stewie Griffin', '.', ''), 
       repeat('#',26), 'abcdefghijklmnopqrstuvwxyz'
    ), '#','' ), 
  ' ','.' ) ||'.' 
from t1; 


-- MySQL
select case
  when cnt = 2 then
     trim(trailing '.' from
       concat_ws('.',
       substr(substring_index(name,' ',1),1,1),
       substr(name, length(substring_index(name,' ',1))+2,1),
       substr(substring_index(name,' ',-1),1,1), '.')
     )
  else
     trim(trailing '.' from
       concat_ws('.', substr(substring_index(name,' ',1),1,1), substr(substring_index(name,' ',-1),1,1))
      )
  end as initials
  from (
   select name,length(name)-length(replace(name,' ','')) as cnt
  from (
   select replace('Stewie Griffin','.','') as name from t1
     ) y
 ) x;

-- Oracle and PostgreSQL
select replace(
 replace( 
   translate(
      replace('Stewie Griffin', '.', ''), 
      'abcdefghijklmnopqrstuvwxyz', 
      rpad('#',26,'#') 
    ), '#','' 
   ),' ','.' ) ||'.' from t1; 


-- SQL Server
select replace(
   replace(
       translate(replace('Stewie Griffin', '.', ''),
       'abcdefghijklmnopqrstuvwxyz',
       replicate('#',26) 
      ), '#','' 
     ),' ','.' ) + '.'
from t1;


-- DB2
select replace(
         replace(translate(replace('Stewie Griffin', '.', ''),
         repeat('#',26), 'abcdefghijklmnopqrstuvwxyz'
    ),'#',''),' ','.') || '.'
from t1; 

-- Oracle and PostgreSQL
select replace(
  replace(
    translate(replace('Stewie Griffin','.',''),
    'abcdefghijklmnopqrstuvwxyz',
    rpad('#',26,'#') ),'#',''
  ),' ','.') || '.'
from t1;



-- MySQL
select 
   concat_ws('.',
     substr(substring_index(name, ' ',1),1,1),
     substr(substring_index(name,' ',-1),1,1),
  '.' ) a
from (
  select 'Stewie Griffin' as name from t1
) x; 



-- ###
-- Ordering by Parts of a String
-- order your result set based on a substring, (on the last two characters of each name)


-- DB2, Oracle, MySQL, and PostgreSQL
select ename from emp order by substr(ename,length(ename)-1,); 

-- SQL Server
select ename from emp  order by substring(ename,len(ename)-1,2);



-- ###
-- Ordering by a Number in a String

create view V as
  select e.ename ||' '|| cast(e.empno as char(4))||' '|| d.dname as data
  from emp e, dept d
where e.deptno=d.deptno; 


-- Oracle
select data from V order by
 to_number(
   replace( translate(data,
   replace( translate(data,'0123456789','##########'), '#'),
 rpad('#',20,'#')),'#')
); 
 

-- PostgreSQL
SELECT data FROM V ORDER BY  
   cast( 
      replace( 
        translate(DATA,  replace( translate(DATA, '0123456789', '##########'), '#', ''), 
        rpad('#', 20, '#')
       ), 
      '#', 
      ''
    ) AS integer
);


SELECT DATA FROM V ORDER BY 
  to_number(
     replace(
        translate(DATA, 
            replace(translate(DATA, '0123456789', '##########'), '#'), 
            rpad('#', length(DATA), '#')
          ), 
       '#')
    );
