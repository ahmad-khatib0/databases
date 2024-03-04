
# this statement will load the EMPLOYEES data from Oracle.. assuming 
# that we’ve loaded the data into nodelocal storage:
# 
IMPORT INTO  "EMPLOYEES" 
   ( "EMPLOYEE_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","JOB_ID","SALARY","COMMISSION_PCT","MANAGER_ID","DEPARTMENT_ID")
   CSV DATA ("nodelocal://1/employees.csv") WITH skip='1', nullif = '';

# Note that during an IMPORT INTO, all foreign key constraints are invalidated on the
# target table, so you have to use VALIDATE CONSTRAINT to revalidate the data.


