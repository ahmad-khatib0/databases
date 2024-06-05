
CREATE TABLE job_status (
  id bigserial not null primary key,
  status text not null,
  restartdata bigint
);

CREATE OR REPLACE FUNCTION job_start_new ()
RETURNS bigint
LANGUAGE plpgsql
AS $$
DECLARE
  p_id BIGINT;
BEGIN
    INSERT INTO job_status (status, restartdata) VALUES ('START', 0)
    RETURNING id INTO p_id;
  RETURN p_id;
END; $$;

CREATE OR REPLACE FUNCTION job_get_status (jobid bigint)
RETURNS bigint
LANGUAGE plpgsql
AS $$
DECLARE
  rdata BIGINT;
BEGIN
    SELECT restartdata INTO rdata FROM job_status
    WHERE status != 'COMPLETE' AND id = jobid;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'job id does not exist';
  END IF;
  RETURN rdata;
  END; 
$$;

CREATE OR REPLACE PROCEDURE
job_update (jobid bigint, rdata bigint)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE job_status
      SET status = 'IN PROGRESS' ,restartdata = rdata
    WHERE id = jobid;
  END; $$;

CREATE OR REPLACE PROCEDURE job_complete (jobid bigint)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE job_status SET status = 'COMPLETE'
    WHERE id = jobid;
  END; $$;


CREATE OR REPLACE PROCEDURE annual_pay_rise (job bigint)
LANGUAGE plpgsql AS $$
DECLARE
    job_empid bigint;
    c NO SCROLL CURSOR FOR
      SELECT * FROM employee 
      WHERE job_code = 'A2' AND empid > job_empid
      ORDER BY empid;
BEGIN
    SELECT job_get_status(job) INTO job_empid;
FOR r IN c LOOP
    UPDATE employee SET salary = salary * 1.02
    WHERE empid = r.empid;
  IF mod (r.empid, 100) = 0 THEN
    CALL job_update(job, r.empid);
    COMMIT;
  END IF;
END LOOP;
CALL job_complete(job);
END; $$;


-- First of all, we start a new job:
SELECT job_start_new();

-- Then, we execute our procedure, passing the job number to it. Let’s say this returns 8474:
CALL annual_pay_rise(8474);

-- f the procedure is interrupted, we will restart from the correct 
-- place, without needing to specify any changes:
CALL annual_pay_rise(8474);

