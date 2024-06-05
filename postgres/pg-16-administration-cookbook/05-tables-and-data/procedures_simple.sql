CREATE TABLE employee (
  empid BIGINT NOT NULL PRIMARY KEY ,
  job_code TEXT NOT NULL ,
  salary NUMERIC NOT NULL
);

INSERT INTO employee VALUES (1, 'A1', 50000.00);
INSERT INTO employee VALUES (2, 'B1', 40000.00);
INSERT INTO employee SELECT generate_series(10,1000), 'A2', 10000.00;

-- a case where we need to update all employees with the 
-- A2 job grade, giving each person a 2% pay rise
--
CREATE PROCEDURE annual_pay_rise (percent numeric)
LANGUAGE plpgsql AS $$
DECLARE
c CURSOR FOR
  SELECT * FROM employee
   WHERE job_code = 'A2';
  BEGIN
    FOR r IN c LOOP
      UPDATE employee
      SET salary = salary * (1 + (percent/100.0))
      WHERE empid = r.empid;
    IF mod (r.empid, 100) = 0 THEN
      COMMIT;
    END IF;
  END LOOP;
  END;
$$;

-- We want to issue regular commits as we go. The preceding procedure is coded so that it issues
-- commits roughly every 100 rows. There’s nothing magical about that number; we just want to
-- break it down into smaller pieces, whether it is the number of rows scanned or rows updated.

-- a simple job restart mechanism. This uses a persistent table 
-- to track changes as they are made, accessed by a simple API:


-- Execute the preceding procedure like this:
CALL annual_pay_rise(2);

