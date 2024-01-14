# Create a Logic Database
CREATE DATABASE sharding_db;

# sharding_db Connect to sharding_db
USE sharding_db;

# Add Data Resource
ADD RESOURCE ds_0 (
    HOST=localhost,
    PORT=3306,
    DB=db0,
    USER=root
);

# Create Sharding Rules
CREATE SHARDING TABLE RULE t_order (
  RESOURCES(ds_0),
  SHARDING_COLUMN=order_id,
  TYPE(NAME=hash_mod,PROPERTIES("sharding-count"=4))
);


-- > SHOW SCHEMA RESOURCES;

-- +------+-------+-----------+------+------+-----------+
-- | name | type  | host      | port | db   | attribute |
-- | ds_0 | MySQL | 127.0.0.1 | 3306 | db0  | ...       |
-- +------+-------+-----------+------+------+-----------+
-- 1 rows in set (0.01 sec)


-- mysql> SHOW SHARDING TABLE RULES;

show sharding table rules;
-- +---------+---------------------+---------------------+-----------------------+-------------------------------+--------------------------------+
-- | table   | actual_data_sources | table_strategy_type | table_sharding_column | table_sharding_algorithm_type | table_sharding_algorithm_props |
-- +---------+---------------------+---------------------+-----------------------+-------------------------------+--------------------------------+
-- | t_order | ds_0                | hash_mod            | order_id              | hash_mod                      | sharding-count=4               |
-- +---------+---------------------+---------------------+-----------------------+-------------------------------+--------------------------------+
-- 1 row in set (0.01 sec)



PREVIEW select * from t_order;

-- +------------------+------------------------------------------------+
-- | data_source_name | sql                                            |
-- +------------------+------------------------------------------------+
-- | ds_0             | select * from t_order_0 ORDER BY order_id ASC  |
-- | ds_0             | select * from t_order_1 ORDER BY order_id ASC  |
-- | ds_0             | select * from t_order_2 ORDER BY order_id ASC  |
-- | ds_0             | select * from t_order_3 ORDER BY order_id ASC  |
-- +------------------+------------------------------------------------+
-- 4 rows in set (0.01 sec)

-- mysql> 
select Host, User from mysql.`user`;

-- +-----------+---------------+
-- | Host      | User          |
-- +-----------+---------------+
-- | %         | root          |
-- | localhost | mysql.session |
-- | localhost | mysql.sys     |
-- | localhost | root          |
-- +-----------+---------------+
-- 4 rows in set (0.00 sec)

