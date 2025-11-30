# Redis Command Cheat Sheet

## Key Commands

| Command               | Description                    | Example                      |
| --------------------- | ------------------------------ | ---------------------------- |
| `DEL key`             | Delete a key                   | `DEL user:123`               |
| `EXISTS key`          | Check if key exists            | `EXISTS user:123`            |
| `EXPIRE key seconds`  | Set key expiration             | `EXPIRE user:123 3600`       |
| `TTL key`             | Get time to live               | `TTL user:123`               |
| `PERSIST key`         | Remove expiration              | `PERSIST user:123`           |
| `KEYS pattern`        | Find keys by pattern           | `KEYS user:*`                |
| `TYPE key`            | Get key type                   | `TYPE user:123`              |
| `RENAME key newkey`   | Rename key                     | `RENAME user:123 user:456`   |
| `RENAMENX key newkey` | Rename if newkey doesn't exist | `RENAMENX user:123 user:456` |

## String Operations

| Command                        | Description         | Example                     |
| ------------------------------ | ------------------- | --------------------------- |
| `SET key value`                | Set string value    | `SET username "john"`       |
| `GET key`                      | Get string value    | `GET username`              |
| `SETEX key seconds value`      | Set with expiration | `SETEX token 3600 "abc123"` |
| `SETNX key value`              | Set if not exists   | `SETNX lock:resource true`  |
| `MSET key1 value1 key2 value2` | Set multiple keys   | `MSET name "John" age "30"` |
| `MGET key1 key2`               | Get multiple values | `MGET name age`             |
| `INCR key`                     | Increment integer   | `INCR counter`              |
| `DECR key`                     | Decrement integer   | `DECR counter`              |
| `INCRBY key increment`         | Increment by amount | `INCRBY counter 5`          |
| `DECRBY key decrement`         | Decrement by amount | `DECRBY counter 3`          |
| `APPEND key value`             | Append to string    | `APPEND name " Doe"`        |
| `GETRANGE key start end`       | Get substring       | `GETRANGE name 0 3`         |
| `STRLEN key`                   | Get string length   | `STRLEN name`               |

## Hash Operations (Perfect for objects/structs)

| Command                                 | Description               | Example                                  |
| --------------------------------------- | ------------------------- | ---------------------------------------- |
| `HSET key field value`                  | Set hash field            | `HSET user:123 name "John"`              |
| `HGET key field`                        | Get hash field            | `HGET user:123 name`                     |
| `HMSET key field1 value1 field2 value2` | Set multiple fields       | `HMSET user:123 name "John" age "30"`    |
| `HMGET key field1 field2`               | Get multiple fields       | `HMGET user:123 name age`                |
| `HGETALL key`                           | Get all fields and values | `HGETALL user:123`                       |
| `HDEL key field1 field2`                | Delete fields             | `HDEL user:123 age`                      |
| `HEXISTS key field`                     | Check if field exists     | `HEXISTS user:123 name`                  |
| `HKEYS key`                             | Get all field names       | `HKEYS user:123`                         |
| `HVALS key`                             | Get all field values      | `HVALS user:123`                         |
| `HLEN key`                              | Get number of fields      | `HLEN user:123`                          |
| `HINCRBY key field increment`           | Increment field value     | `HINCRBY user:123 visits 1`              |
| `HSETNX key field value`                | Set field if not exists   | `HSETNX user:123 email "john@email.com"` |

## List Operations

| Command                                 | Description           | Example                                  |
| --------------------------------------- | --------------------- | ---------------------------------------- |
| `LPUSH key value1 value2`               | Push to left          | `LPUSH tasks "task1" "task2"`            |
| `RPUSH key value1 value2`               | Push to right         | `RPUSH tasks "task3" "task4"`            |
| `LPOP key`                              | Pop from left         | `LPOP tasks`                             |
| `RPOP key`                              | Pop from right        | `RPOP tasks`                             |
| `LLEN key`                              | Get list length       | `LLEN tasks`                             |
| `LRANGE key start stop`                 | Get range of elements | `LRANGE tasks 0 -1`                      |
| `LINDEX key index`                      | Get element at index  | `LINDEX tasks 0`                         |
| `LINSERT key BEFORE\|AFTER pivot value` | Insert element        | `LINSERT tasks BEFORE "task2" "task1.5"` |
| `LREM key count value`                  | Remove elements       | `LREM tasks 1 "task1"`                   |
| `LSET key index value`                  | Set element at index  | `LSET tasks 0 "new_task"`                |

## Set Operations

| Command                    | Description                      | Example                        |
| -------------------------- | -------------------------------- | ------------------------------ |
| `SADD key member1 member2` | Add members                      | `SADD tags "redis" "database"` |
| `SREM key member1 member2` | Remove members                   | `SREM tags "database"`         |
| `SMEMBERS key`             | Get all members                  | `SMEMBERS tags`                |
| `SISMEMBER key member`     | Check if member exists           | `SISMEMBER tags "redis"`       |
| `SCARD key`                | Get number of members            | `SCARD tags`                   |
| `SINTER key1 key2`         | Intersection of sets             | `SINTER tags1 tags2`           |
| `SUNION key1 key2`         | Union of sets                    | `SUNION tags1 tags2`           |
| `SDIFF key1 key2`          | Difference of sets               | `SDIFF tags1 tags2`            |
| `SPOP key count`           | Remove and return random members | `SPOP tags 1`                  |
| `SRANDMEMBER key count`    | Get random members               | `SRANDMEMBER tags 2`           |

## Sorted Set Operations

| Command                                  | Description                  | Example                                 |
| ---------------------------------------- | ---------------------------- | --------------------------------------- |
| `ZADD key score member`                  | Add member with score        | `ZADD leaderboard 100 "player1"`        |
| `ZRANGE key start stop [WITHSCORES]`     | Get range by index           | `ZRANGE leaderboard 0 -1 WITHSCORES`    |
| `ZREVRANGE key start stop [WITHSCORES]`  | Get reverse range            | `ZREVRANGE leaderboard 0 -1 WITHSCORES` |
| `ZRANGEBYSCORE key min max [WITHSCORES]` | Get range by score           | `ZRANGEBYSCORE leaderboard 50 200`      |
| `ZREM key member`                        | Remove member                | `ZREM leaderboard "player1"`            |
| `ZSCORE key member`                      | Get member's score           | `ZSCORE leaderboard "player1"`          |
| `ZRANK key member`                       | Get member's rank            | `ZRANK leaderboard "player1"`           |
| `ZREVRANK key member`                    | Get reverse rank             | `ZREVRANK leaderboard "player1"`        |
| `ZCARD key`                              | Get number of members        | `ZCARD leaderboard`                     |
| `ZCOUNT key min max`                     | Count members in score range | `ZCOUNT leaderboard 50 200`             |
| `ZINCRBY key increment member`           | Increment member's score     | `ZINCRBY leaderboard 25 "player1"`      |

## HyperLogLog Operations

| Command                                 | Description           | Example                          |
| --------------------------------------- | --------------------- | -------------------------------- |
| `PFADD key element1 element2`           | Add elements          | `PFADD visitors "user1" "user2"` |
| `PFCOUNT key1 key2`                     | Count unique elements | `PFCOUNT visitors`               |
| `PFMERGE destkey sourcekey1 sourcekey2` | Merge HyperLogLogs    | `PFMERGE all_visitors day1 day2` |

## Geo Operations

| Command                                        | Description        | Example                                    |
| ---------------------------------------------- | ------------------ | ------------------------------------------ |
| `GEOADD key longitude latitude member`         | Add location       | `GEOADD cities 13.4050 52.5200 "Berlin"`   |
| `GEOPOS key member1 member2`                   | Get positions      | `GEOPOS cities "Berlin"`                   |
| `GEODIST key member1 member2 unit`             | Get distance       | `GEODIST cities "Berlin" "Paris" km`       |
| `GEORADIUS key longitude latitude radius unit` | Find within radius | `GEORADIUS cities 13.4050 52.5200 100 km`  |
| `GEORADIUSBYMEMBER key member radius unit`     | Find near member   | `GEORADIUSBYMEMBER cities "Berlin" 200 km` |

## Pub/Sub Operations

| Command                          | Description               | Example                      |
| -------------------------------- | ------------------------- | ---------------------------- |
| `PUBLISH channel message`        | Publish message           | `PUBLISH news "Hello World"` |
| `SUBSCRIBE channel1 channel2`    | Subscribe to channels     | `SUBSCRIBE news sports`      |
| `UNSUBSCRIBE channel1 channel2`  | Unsubscribe from channels | `UNSUBSCRIBE news`           |
| `PSUBSCRIBE pattern1 pattern2`   | Subscribe to patterns     | `PSUBSCRIBE news.*`          |
| `PUNSUBSCRIBE pattern1 pattern2` | Unsubscribe from patterns | `PUNSUBSCRIBE news.*`        |

## Transaction Operations

| Command           | Description            | Example         |
| ----------------- | ---------------------- | --------------- |
| `MULTI`           | Start transaction      | `MULTI`         |
| `EXEC`            | Execute transaction    | `EXEC`          |
| `DISCARD`         | Discard transaction    | `DISCARD`       |
| `WATCH key1 key2` | Watch keys for changes | `WATCH balance` |
| `UNWATCH`         | Unwatch all keys       | `UNWATCH`       |

## Server & Connection Commands

| Command                      | Description                   | Example                      |
| ---------------------------- | ----------------------------- | ---------------------------- |
| `PING`                       | Test connection               | `PING`                       |
| `ECHO message`               | Echo message                  | `ECHO "Hello"`               |
| `SELECT index`               | Select database               | `SELECT 1`                   |
| `AUTH password`              | Authenticate                  | `AUTH mypassword`            |
| `QUIT`                       | Close connection              | `QUIT`                       |
| `INFO section`               | Get server info               | `INFO memory`                |
| `CLIENT LIST`                | List clients                  | `CLIENT LIST`                |
| `CONFIG GET parameter`       | Get config                    | `CONFIG GET maxmemory`       |
| `CONFIG SET parameter value` | Set config                    | `CONFIG SET maxmemory 100mb` |
| `FLUSHDB`                    | Delete all keys in current DB | `FLUSHDB`                    |
| `FLUSHALL`                   | Delete all keys in all DBs    | `FLUSHALL`                   |
| `DBSIZE`                     | Get number of keys            | `DBSIZE`                     |
| `BGSAVE`                     | Save DB in background         | `BGSAVE`                     |
| `SAVE`                       | Save DB synchronously         | `SAVE`                       |
| `LASTSAVE`                   | Get timestamp of last save    | `LASTSAVE`                   |

## Scripting (Lua)

| Command                                    | Description            | Example                                            |
| ------------------------------------------ | ---------------------- | -------------------------------------------------- |
| `EVAL script numkeys key1 key2 arg1 arg2`  | Execute Lua script     | `EVAL "return redis.call('GET', KEYS[1])" 1 mykey` |
| `EVALSHA sha1 numkeys key1 key2 arg1 arg2` | Execute script by SHA1 | `EVALSHA abc123... 1 mykey`                        |
| `SCRIPT LOAD script`                       | Load script            | `SCRIPT LOAD "return redis.call('GET', KEYS[1])"`  |
| `SCRIPT EXISTS sha1 sha2`                  | Check if scripts exist | `SCRIPT EXISTS abc123... def456...`                |
| `SCRIPT FLUSH`                             | Remove all scripts     | `SCRIPT FLUSH`                                     |
| `SCRIPT KILL`                              | Kill running script    | `SCRIPT KILL`                                      |

## Bit Operations

| Command                             | Description        | Example                      |
| ----------------------------------- | ------------------ | ---------------------------- |
| `SETBIT key offset value`           | Set bit at offset  | `SETBIT mybits 7 1`          |
| `GETBIT key offset`                 | Get bit at offset  | `GETBIT mybits 7`            |
| `BITCOUNT key start end`            | Count set bits     | `BITCOUNT mybits`            |
| `BITOP operation destkey key1 key2` | Bitwise operations | `BITOP AND result key1 key2` |
| `BITPOS key bit start end`          | Find first bit set | `BITPOS mybits 1`            |

## Stream Operations

| Command                                                      | Description           | Example                                                         |
| ------------------------------------------------------------ | --------------------- | --------------------------------------------------------------- |
| `XADD key ID field value field value`                        | Add to stream         | `XADD mystream * name "John" age "30"`                          |
| `XRANGE key start end COUNT count`                           | Read range            | `XRANGE mystream - + COUNT 10`                                  |
| `XREVRANGE key start end COUNT count`                        | Read reverse range    | `XREVRANGE mystream + - COUNT 10`                               |
| `XREAD COUNT count STREAMS key ID`                           | Read from streams     | `XREAD COUNT 2 STREAMS mystream 0`                              |
| `XGROUP CREATE key groupname ID`                             | Create consumer group | `XGROUP CREATE mystream mygroup $`                              |
| `XREADGROUP GROUP group consumer COUNT count STREAMS key ID` | Read from group       | `XREADGROUP GROUP mygroup consumer1 COUNT 1 STREAMS mystream >` |
| `XACK key groupname ID`                                      | Acknowledge message   | `XACK mystream mygroup 12345-0`                                 |

## Common Patterns & Examples

### Session Storage (Hash)

```redis
HSET session:abc123 user_id "123" created_at "1672531200" expires_at "1672617600"
HGETALL session:abc123
EXPIRE session:abc123 3600
```

### Caching (String)

```redis
SETEX user:profile:123 300 '{"name":"John","age":30}'
GET user:profile:123
```

### Leaderboard (Sorted Set)

```redis
ZADD leaderboard 100 "player1" 85 "player2" 120 "player3"
ZREVRANGE leaderboard 0 9 WITHSCORES
ZINCRBY leaderboard 15 "player1"
```

### Rate Limiting

```redis
INCR rate_limit:ip:192.168.1.1
EXPIRE rate_limit:ip:192.168.1.1 60
```

### Message Queue (List)

```redis
LPUSH queue:emails '{"to":"user@email.com","subject":"Hello"}'
RPOP queue:emails
```
