EXPORT INTO CSV 'nodelocal://self/rides.csv' WITH nullas='' FROM TABLE rides;

-- nodelocal storage is located in a deployment-specific location. On a single-node server, 
-- we might find it in the extern directory under the installation location:
-- $ ls -l /usr/local/var/cockroach/extern/rides

-- We can also export data to cloud storage locations, such as an Amazon S3 bucket:
EXPORT INTO CSV 
<<<<<<< HEAD
"s3://cockroachdefinitiveguide/?AWS_ACCESS_KEY_ID=${key}&AWS_SECRET_ACCESS_KEY=${key}" 
=======
"s3://cockroachdefinitiveguide/?AWS_ACCESS_KEY_ID=0N4RRX7VG5WQS0Y0DTG2&AWS_SECRET_ACCESS_KEY=kLKkZjS/i98CN8oR6vp56lHC0ecgyf8zePCKd+aW" 
>>>>>>> 07638645ca5da12c42dcee9ffd3b9706eaa51e8b
WITH nullas='' FROM TABLE rides;

-- The EXPORT command can accept a SELECT statement that filters and projects the data to be exported:
EXPORT INTO CSV 
'userfile://defaultdb.public.userfiles_guy/'
WITH nullas='' FROM  SELECT rider_id,start_time,end_time FROM rides WHERE city='amsterdam';


