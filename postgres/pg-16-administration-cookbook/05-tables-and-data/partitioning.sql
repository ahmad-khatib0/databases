CREATE TABLE transactions (
  tstamp TIMESTAMP WITH TIME ZONE PRIMARY KEY,
  amount NUMERIC
)
PARTITION BY RANGE (tstamp);


-- so now e.g: we can keep transactions separated by the year in which they took place:
CREATE TABLE transactions_2021
  PARTITION OF transactions
  FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');

CREATE TABLE transactions_2022
  PARTITION OF transactions
  FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE transactions_2023
  PARTITION OF transactions
  FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- if we have older transactions that we want to move into this table? If we don’t care
-- about creating individual partitions for them, we can lump them into the DEFAULT partition
CREATE TABLE transactions_older
PARTITION OF transactions DEFAULT;


-- There’s more...
-- This was RANGE partitioning, but other methods are available, such as LIST, where we specify
-- a list of values to be included in each partition, and HASH, which is used to create a number of
-- partitions of roughly equal size.



