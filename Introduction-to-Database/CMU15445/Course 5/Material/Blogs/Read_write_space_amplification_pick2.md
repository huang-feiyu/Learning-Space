### Read, write & space amplification - pick 2

Good things [come in threes](https://en.wikipedia.org/wiki/Rule_of_three_(writing)), then reality bites and you must choose at most two. This choice is well known in distributed systems with [CAP](http://dbmsmusings.blogspot.com/2012/10/ieee-computer-issue-on-cap-theorem.html), [PACELC](http://dbmsmusings.blogspot.com/2010/04/problems-with-cap-and-yahoos-little.html) and [FIT](http://dbmsmusings.blogspot.com/2015/10/why-mongodb-cassandra-hbase-dynamodb_28.html). There is a similar choice for database engines. An algorithm can optimize for at most two from [read](http://mysqlha.blogspot.com/2011/08/read-amplification-factor.html), [write](https://en.wikipedia.org/wiki/Write_amplification) and space amplification. These are metrics for efficiency and performance. This means one algorithm is unlikely to be better than another at all three. For example a [B-Tree](https://en.wikipedia.org/wiki/B-tree) has less read amplification than an [LSM](https://en.wikipedia.org/wiki/Log-structured_merge-tree) while an LSM has less write amplification than a B-Tree. I abbreviate the metrics as read-amp, write-amp and space-amp. I also abbreviate this as *the framework*.

The framework assumes a database workload that consists of point-queries, range-queries of length N and writes. Were I to add a delete operation then this would match the RocksDB and [LevelDB API](https://github.com/google/leveldb). The write is a *blind-write* as it doesn't imply a read prior to the write.

This is part one of a topic that requires several blog posts. The second post will compare a B-Tree and LSM using the framework. The third post will argue that an algorithm cannot be optimal for all three metrics.



#### Purpose


Read, write and space amplification explain performance and efficiency when evaluating algorithms for real and potential workloads. They aren't a replacement for [Big O notation](https://en.wikipedia.org/wiki/Analysis_of_algorithms). They usually assume a specific workload and configuration including RAM size, database size and type of storage.

We began using the framework to compare InnoDB and RocksDB because better performance is [an insufficient metric](http://smalldatum.blogspot.com/2015/11/define-better-for-small-data-dbms.html) on which to choose an algorithm. Endurance (write amp) and capacity (space amp) matter when using flash. IOPs (read amp for point and range queries, write amp for writes) matters when using disk.

The framework is useful for understanding the compromises made in search of better QPS. It is easy to trade write for space or read efficiency in write-optimized algorithms but these trades should be disclosed because they are not free. New algorithms can show better write throughput than RocksDB by making range reads less efficient but the [Linkbench workload](https://github.com/facebook/linkbench) needs efficient writes and efficient range reads.

The framework is useful because key comparisons aren't created equal. Traditional algorithm analysis is great for understanding in-memory performance via bounds on the number of key comparisons. But big-O notation is harder to use when some keys are read from cache, others from RAM and some from disk. Constant factors matter. The difference between 1.2 and 1.5 disk reads per query can be a big deal.

####  

#### Read amplification


Read-amp is the amount of work done per logical read operation. This can be defined for in-memory databases, persistent databases assuming no cache (worst-case behavior) and persistent databases assuming some cache (average-case behavior). The work done in-memory can be the number of key comparisons and traditional algorithm analysis can be used. The work done on-disk includes the number of bytes transferred and seeks (seeks matter on disks, not on NVM). The work done can also include the cost of decompressing data read from storage which is a function of the read block size and compression algorithm.

Read-amp is defined separately for point and range queries. For range queries the range length matters (the number of rows to be fetched). In [Linkbench](https://github.com/facebook/linkbench) the average range query fetches about 20 rows.

Read-amp can also be defined for point queries on keys that don't exist. Some algorithms use a bloom filter to avoid disk IO for keys that don't exist. Queries for non-existent keys is common in some workloads. Bloom filters can't be used for a range query. The most frequent query in Linkbench is a range query that includes an equality predicate on the first two columns of the range query index. With RocksDB we define a [prefix bloom filter](https://github.com/facebook/rocksdb/wiki/RocksDB-Bloom-Filter) to benefit from that.

####  

#### Write amplification


Write-amp is the amount of work done per write operation. This can include the number of bytes written to storage and disk seeks per logical write operation. This can be split into in-memory and on-disk write-amp but I frequently ignore in-memory write-amp.

There is usually a cost to pay in storage reads and writes following a logical write. With write-amp we are ignoring the read cost. The read cost is immediate for an update-in-place algorithm like a B-Tree as a page must be read to modify it. The read cost is deferred for a write-optimized algorithm like an LSM as compaction is done in the background and decoupled from the logical write. There is usually some write cost that is not deferred - updating in-memory structures and writing a redo log.

With flash storage there is usually additional write-amp from the [garbage collection done by the FTL](https://en.wikipedia.org/wiki/Flash_memory_controller#Garbage_collection) to provide flash blocks that can be rewritten. Be careful about assuming too much about the benefit of sequential and large writes from a write-optimized database engine. While the physical erase block size on a NAND chip is not huge, many storage devices have something that spans physical erase blocks when doing GC that I will call a logical erase block. When data with different lifetimes ends up in the same logical erase block then the long-lived data will be copied out and increase flash GC write-amp (WAF greater than 1).  I look forward to the [arrival of multi-stream](https://www.usenix.org/system/files/conference/hotstorage14/hotstorage14-paper-kang.pdf) to reduce flash GC WAF.



#### Space amplification


Space-amp is the ratio of the size of the database to the size of the data in the database. Compression decreases space-amp. It is increased by fragmentation with a B-Tree and old versions of rows with an LSM. A low value for space-amp is more important with flash storage than disk because of the price per GB for storage capacity.



#### Efficiency & Performance


I work on small data systems. Small data is another name [for OLTP](https://en.wikipedia.org/wiki/Online_transaction_processing). Small data workloads are highly concurrent and with concurrency better efficiency usually implies better performance. But performance and efficiency are not always strongly correlated. For example an algorithm with a high read-amp for range queries might hide the extra latency by doing disk reads in parallel. This improves response time but doesn't improve efficiency and the algorithm with less read-amp will sustain more QPS at higher concurrency.