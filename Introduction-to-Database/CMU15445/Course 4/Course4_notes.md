# CMU-154-45: 

## Before this course:

* Required Reading:  <a href=../Resources/数据库系统概念_原书第6版.pdf>Chapter 10.5-10.8</a>

### Chapter 10.5-10.8

#### 文件组织(more)
* 将一条或者多条记录存储于一个块中，一般是4~8KB. 也叫做page.
* Heap file organization 
* Sequential file organization: 使用搜索码，基本是搜索空闲空间，如果没有则存储在溢出区。
* Hashing file organization
* multitable clustering file organization: 一般不使用

#### 数据字典存储
* metadata: 元数据，关于数据的数据
* data dictionary/ system catalog: 关于关系的关系模式和其他元数据存储的地方
    * 每个关系的名字
    * 关系的属性名字
    * 属性的域和长度
    * 在数据库上定义的视图的名字和定义
    * 完整性约束
    * 系统用户数据
    * 关系统计数据和描述数据
    * 存储组织、关系存储位置
    * 索引信息
metabase组成了一个小的微型数据库，一般在数据库中存储本身的信息，简化了系统总体结构。

#### 数据库缓冲区
DBMS的一个主要目的就是尽量减少磁盘与存储器之间传输的块数目，我们在主存储器中保留尽可能多的块。因为在主存储器中存储这么多块是不可能的，所以需要用buffer存储磁盘块的拷贝的一部分。

##### Buffer Manager
* DBMS调用块时，如果在缓冲区中，就将主存储器中的地址传给请求者；如果不在，那么分配空间，如果需要的话将其他块移除。
* Buffer replacement strategy: 当缓冲区没有剩余空间，则新块存储前，使用Least Recently Used策略，即最近访问最少的块被写回硬盘，移除。
* pinned block: 块的更新操作，使DBMS能够从系统崩溃中恢复，这些块不允许被写回磁盘
* forced output of block: 磁盘上的数据一般都可以保留

##### Buffer Replacement Strategy
* LRU: Least Recently Used,替换一个块则替换最近访问最少的块
* MRU: Most Recently Used

### Papers: 

[chou1986](./Material/chou1986.pdf)

[to blob or not blob in the database](./Material/tr-2006-45.pdf)

## [In the Course](https://www.youtube.com/watch?v=1D81vXw2T_w&list=PLSE8ODhjZXjbohkNBWQs_otTrBTrjyohi&index=4&ab_channel=CMUDatabaseGroup)

### Tuple Storage
* Tuple: a sequence of bytes
* DBMS's job to interpret those bytes into attribute types and values
* Cataglog: schema information about that the system uses to figure out the
  tuple'layout

#### Data Representation
* INTEGER/BIGINT/SMALLINT/TINYINT: C/C++ Representation
* FLOAT/REAL vs. NUMERIC/DECIMAL: **IEEE-754 Standard** / Fixed-point Decimals
* VARCHAR/VARBINARY/TEXT/BLOB: Header with length, followed by data bytes
* TIME/DATE/TIMSTAMP: 32/64 integer of (micro) seconds since UNIX epoch

#### VARIABLE PRECISION NUMBERS
* native C/C++: FLOAT, REAL/DOUBLE
* store directly as specified by IEEE-754
* FASTER
* NOT precise: hardware's fault, **ROUND ERRORS**

#### FIXED PRECISION NUMBERS
* NUMERIC, DECIMAL: with arbitrary precision and scale
* VARCHAR: stored in a exact, variable-length binary representaion with
  additional metadata
* A little slower than variable precision numbers 
* Precise: DBMS Display may round for you
* POSTGRES: NUMBERIC, use varchar

#### LARGE VALUES
* Not a single page: store in separate 'overflow' pages or TOAST 
* External value storage: BLOB(or BFILE, or FILESTREAM),
  database can not manipulate the contents of an external file
    * no protections: durability, transaction
* 256KB is OK to store in database

### System Catalog
* metadata
    * Tables, columns, indexes, views
    * Users, permissions
    * Internal 
* DBMS store their catalog in itself: INFORMATION_SCHEMA
    * specified code for the table 
    * wrap object abstraction around tuples

**If we rely on database, we cannot control it.**

### Storage Models
Reltaional model does not specify that we have to store all a tuple's
 attributes together in a single page

#### OLTP
* On-line Transaction Processing
* Simple queries that read/update a small amount of data that is related to a
  single entity in the database
* Usually the kind of application that people build first

#### OLAP
* On-line Analytical Processing
* Complex queries that read large portions of the database spanning multiple
  entity

**HTAP: Have both the part of OLTP's and OLAP's advantages: Hybrid
Transaction/Analytical Processing**

#### NSM
* N-ary storage model: All records in a DB relation are stored together
  A.K.A "row storage"
* Ideal: for OLTP workloads where queries tend to operate only on an individual entity
  and insert-heavy workloads
* Advantages: Fast insert, update, delete; Good for query that needs the entire
  entity
* Disadvantages: sometimes need to query entire page, with some useless data

#### DSM
* Decomposition storage model: stores the values of a single attribute for all
  tuples contiguously in a page  A.K.A "column store"
* Ideal: for OLAP workloads where read-only queries perform large scans over a
  subset of the table's attributes
* tuple identification: 
    * 1: Fixed-length Offsets, each value is the same length for an attribute
    * 2: Embedded Tuple Ids, each value is stored withs its tuple id in a column
* Advantages: Reduces the amount wasted I/O; Better query processing and data
  compression
* Disadvantages:  slow for point queries, inserts, updates, deletes

### Conclusion
* The storage manager is not entirely independent from the rest of the DBMS
* OLTP: Row Store
* OLAP: Column Store

## Exercise

