-- Vertical Partitioning
-- Vertical partitioning involves breaking up a table into multiple tables, each of which
-- contains a different set of rows. This is typically done to reduce the amount of work
-- that needs to be completed when updating a row and can also reduce the conflicts
-- that occur when two columns are subject to high concurrent update activity.
-- For instance, consider an Internet of Things (IoT) application in which a city’s
-- current temperature and air pressure are updated multiple times a second by weather
-- sensor devices across the city:

CREATE TABLE cityWeather (
  city_id uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  city_name varchar NOT NULL,
  currentTemp float NOT NULL,
  currentAirPressure float NOT NULL
);


-- The temperature values and air pressure readings come from different systems, and
-- we’re concerned that they will cause transaction conflicts when they attempt to
-- change the same row simultaneously.
-- We could partition the table into two tables to avoid this conflict:
CREATE TABLE cityTemp (
  city_id uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  city_name varchar NOT NULL,
  currentTemp float NOT NULL
);

CREATE TABLE cityPressure (
  city_id uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  city_name varchar NOT NULL,
  currentTemp float NOT NULL,
  currentAirPressure float NOT NULL
);


-- However, CockroachDB column families provide a solution that does not require us to modify our data 
-- model. column families allow groups of columns to be stored separately in the storage layer.
-- We simply add each measurement to its own family:
CREATE TABLE cityWeather (
  city_id uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  city_name varchar NOT NULL,
  currentTemp float NOT NULL,
  currentAirPressure float NOT NULL,
  FAMILY f1 (city_id,city_name),
  FAMILY f2 (currentTemp),
  FAMILY f3 (currentAirPressure)
);



-- Horizontal Partitioning
-- Horizontal partitioning (usually just referred to as partitioning) allows a table or
-- index to be comprised of multiple segments. Some examples are:
-- • Queries can read only the partitions that contain relevant data, reducing the
-- number of logical reads required for a particular query. This technique—known
-- as partition elimination—is particularly suitable for queries that read too great a portion 
-- of the table to be able to leverage an index but still do not need to read the entire table. 
-- • By splitting tables and indexes into multiple segments, parallel processing can
-- be significantly improved since operations can be performed on partitions concurrently.


