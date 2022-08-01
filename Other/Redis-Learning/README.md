# Redis Learning
[redis](https://github.com/redis/redis): 高性能KV-DB (NoSQL)

Port: 6379

## Getting Startted
开始
```bash
redis-server
# 启用守护进程
redis-server daemonize yes
```

cli
```bash
redis-cli
# 远程启动
redis-cli -h {host} -p {port} -a {password}
```

配置
```bash
CONFIG GET {CONFIG_SETTING_NAME}
CONFIG SET {CONFIG_SETTING_NAME} {NEW_CONFIG_NAME}
```

## 数据类型
* String (512MB)
  * `GET`
  * `SET`
* Hash (2<sup>32</sup> - 1)
  * `HDEL`: remove key
  * `HMSET`
  * `HGET`
  * `HGETALL`
* List (2<sup>32</sup> - 1)
  * `lpush` / `rpush`
  * `lpop`
  * `lrange`: 获取索引内的元素
  * `lindex`: 获取索引对应元素值
* Set (2<sup>32</sup> - 1)
  * `sadd`: `sadd key member`
  * `srem`
  * `smembers`
  * `sismember`: Check if specific element in set
* zset (sorted set)
  * `zadd`: `zadd key score member`
  * `ZRANGEBYSOCRE`



