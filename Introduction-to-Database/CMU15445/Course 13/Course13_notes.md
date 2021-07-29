# CMU-15-445: 

## Before this course:
* Required Reading:  <a href=../Resources/数据库系统概念_原书第6版.pdf>Chapter 18</a>

### 并行数据库

###### I/O 并行

通过关系将划分到多张磁盘上来缩减从磁盘上对关系进行检索所需要的时间。并行数据库数据划分最通用的形式是水平分区：关系中的元组划分到多张磁盘上，使得每个元组驻留在一张磁盘上。

* 轮转法：对关系进行任意的扫描，保证了元组在多张磁盘上的平均分布
  * 顺序读取非常方便，但是点查询和范围查询处理很复杂
* 散列划分：通过散列函数进行划分
  * 适用于基于划分属性的点查询和顺序扫描，其他的不太好
* 范围划分：通过设定的范围进行划分
  * 适用于基于划分属性的点查询和范围查询

后两种划分军可能出现skew偏移现象：属性值偏移和划分偏移。

###### 查询间并行

不同查询或者事务彼此并行地执行，可以提高事务吞吐量，每秒内能够支持更大数量的事务。

共享磁盘系统协议：

* 事务对一个页面进行任何读或写访问之前，先用相应的共享或者排他模式封锁该页面。一旦事务获得了页面的共享锁或排他锁之后，它立刻从共享磁盘中读取该页面的最新版本
* 在事务释放一个页面的排他锁以前，它将该页面刷新到共享磁盘中，然后释放封锁

###### 查询内并行

单个查询在多个处理器和磁盘上并行执行。

* 操作内并行：并行地执行每个运算
  * 并行排序：范围划分排序；并行地外部排序归并
  * 并行连接：基于划分的连接；分片-复制连接；基于划分的并行散列连接；并行嵌套循环连接
* 操作间并行：并行地执行一个查询表达式的多个不同的运算
  * 流水线并行
  * 独立并行
* 查询优化


### Papers: 
none

## [In the Course](https://www.youtube.com/watch?v=1D81vXw2T_w&list=PLSE8ODhjZXjbohkNBWQs_otTrBTrjyohi&index=13&ab_channel=CMUDatabaseGroup)
* We discussed last class how to compose operators together to execute a query plan.
* We assumed that the queries execute with a single worker(e.g. thread)
* We now need to talk about how to execute with multiple workers...

##### Why care about parallel execution?
* Increased performance
  * Throughput
  * Latency
* Increased responsiveness and availability
* Potentially lower total cost of ownership(TCO)

### Parallel vs. Distributed
* Database is spread out across multiple resources to improve different aspects of the DBMS
* Appears as a single database instance to the application
  * SQL query for a single-resources DBMS should generate same result on a parallel or distributed
    DBMS

###### Parallel DBMSs:
* Resources are physically close to each other
* Resources communicate with high-speed interconnect
* Communication is assumed to cheap and reliable

###### Distributed DBMSs:
* Resources can be far from each other
* Resources communicate using slower interconnect
* Communication cost and problems cannot be ignored

### Process Models
* A DBMS's process model defines how the system is architected to support concurrent requests from a
  muti-user application
* A worker is the DBMS component that is responsible for executing tasks on behalf of the client and
  returning the results

##### Process per DBMS Worker
Each worker is a separate OS process.
* Relies on OS scheduler
* Use shared-memory for global data structures
* A process crash doesn't take down entire system
* Examples: IBM DB2, PostgreSQL, Oracle

##### Process Pool
A worker uses any process that is free in a pool
* Still relies on OS scheduler and shared memory
* Bad for CPU cache locality
* Examples: IBM DB2, PostgreSQL

##### Thread per DBMS Worker
Single process with multiple worker threads
* DBMS manages its own scheduling
* May or may not use a dispatcher thread
* Thread crash may kill the entire system
* Examples: IBM DB2, MSSQL, MySQL, Oracle

* Using a multi-threaded architecture has several advantages:
  * Less overhead per context switch
  * Do not have to manage shared memory
* The thread per worker model does not mean that the DBMS supports intra-query parallelism
* Almost every DBMS use threads since 10 years ago

### Execution Parallelism

##### Scheduling#
* For each query plan, the DBMS decides where, when, and how to execute it
  * How many tasks should it use?
  * How many CPU cores should it use?
  * What CPU core should the tasks execute on?
  * Where should a task store its output?
* The DBMS always knows more than th OS

#### Inter- vs, Intra-Query Parallelism
* Inter-Query: Different queries are executed concurrently
  * Increases throughput & reduces latency
* Intra-Query: Execute the operations of a single query in parallel
  * Decreases latency for long-running queries

##### Inter-Query Parallelism
* Improve overall performance by allowing multiple queries to execute simultaneously
* If queries are read-only, then this requires little coordination between queries
* If multiple queries are updating the database at the same time, then this is hard to do correctly...

##### Intra-Query Parallelism
* Improve the performance of a single query by executing its operators in parallel
* Think of organization of operators in terms of a producer/consumer paradigm
* There are parallel algorithms for every relational operators
  * Can either have multiple threads access centralized data structures or use partitioning to
    divide work up

###### Intra-Operator(Horizontal)
* Decompose operators into independent fragments that perform the same function on different subsets
of data.
* The DBMS inserts an exchange operator into the query plan to coalesce results from children
  operators

* Exchange Type 1-Gather
  * Combine the results from multiple workers into a single output stream
  * Query plan root must always be a gather exchange
* Exchange Type 2-Repartition
  * Reoragnize multiple input streams across multiple output streams
* Exchange Type 3-Distribute
  * Split a single input stream into multiple output streams

###### Inter-Operator(Vertical)
* Operations are overlapped in order to pipeline data from one stage to the next without
  materialization
* Also called pipelined parallelism

###### Bushy
* Extension of inter-operator parallelism where workers execute multiple operators from different
  segments of a query plan at the same time
* Still need exchange operators to combine intermediate results from segments

#### Observation
* Using additional processes/threads to execute queries in parallel won't help if the disk is always
  the main bottleneck
  * Can make things worse if each worker is read different segments of disk

### I/O Parallelism
Split the DBMS installation across multiple storage devices
* Multiple Disks per database
* One Database per Disk
* One Relation per Disk
* Split Relation across Multiple Disks

##### Multiple Disks per Database
* Configure OS/hardware to store the DBMS's files across multiple storage devices
  * Storage Appliances
  * RAID Configuration
* This is transparent to the DBMS

##### Database Partitioning
* Some DBMSs allow you specify the disk location of each individual database
  * The buffer pool manager maps a page to a disk location
* This is also easy to do at the filesystem level if the DBMS sores each database in a separate
  directory
    * The log file might be shared though

##### Partitioning
* Split single logical table into disjoint physical segments that are stored/managed separately
* Ideally partitioning is transparent to the application
  * The application accesses logical tables and does not care how things are stored
  * Not always true in distributed DBMSs

###### Vertical Partitioning
* Store a table's attributes in a separate location(e.g. file, disk volume)
* Have to store tuple information to reconstruct the original record

### Conclusion
* Parallel execution is important
* Parallel is really hard to get right
  * Coordination Overhead
  * Scheduling
  * Concurrency Issues
  * Resource COntention

## Exercise
