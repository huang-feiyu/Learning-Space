# 1. How dose relational database work?

### Basics

To know how important the time is. We need to every algorithms' time complexity.

##### need to know:

1. A search in a good hash table gives an element in O(1)
2. The best sorting algorithms have an O(N*log(N))) complexity.

And also, the complexity also works for `the memory consumption of an algorithm` and `the disk I/O consumption of an algorithm`.

#### some algorithms and data structure

##### Merge Sort: 

* A common database join operation called the merge join.
* N * log(N)
* Reduce the memory footprint(in place)

##### Array: 

* 2-dimensional array is a table
* row represents a subject
* columns are features
* **when you are looking for a specific value it sucks** O(N) (N is row number)

##### Tree and database index: 

* Suppose you have a tree that contains the column "country" of the table 

* * If you want to know who is working in the UK
  * you look at the tree to get the node that represents the UK
  * inside the `UK node` you'll find the locations of the rows of the UK workers

  And this is a database index

* B+ Tree Index

* * only the lowest nodes store information
  * the other nodes are just here to route to the right node during the search
  * A Excellent way to find the values between A and B
  * But when add of remove a row in database, it is not so good. (But developers have solved this problem)
  * Because of the low-level optimizations the B+Tree needs to be fully balanced.

##### Hash Table:

* Hash Table is useful when you want to quickly look for values.
* And also know how the hash join works
* definition
* *  a key for your elements
  * a hash function for the keys, to get **buckets**(refers to location) of the keys
  * a function to compare the keys
* With a good hash function, the search in a hash table is in O(1)

### Global overview

![global overview of a database](http://coding-geek.com/wp-content/uploads/2015/08/global_overview.png)

**A database is divided into multiple components that interact with each other.**

##### Core components:

* The process manager
* The network manager
* File system manager: Disk IO is the first bottleneck of a database
* The memory manager
* Client manager
* ...

##### Tools:

* Backup manager
* Recovery manager
* Monitor manager: Monitor logging activity
* Administration manager: store metadata
* ...

##### The query manager:

* Query parser
* Query rewriter
* Query optimizer(优化)
* Query executor

##### The data manager:

* Transaction manager
* Cache manager
* Data access manager

### Client manager

Handle the communication with a web sever or an end user/end-application.

(And also refers to the processes when you connect to a database.)

### Query manager

**This part is where the power of a database lies.** An ill-written query is transformed into a fast executable code.

##### **Query  parser: check **

##### Query rewriter: Avoid some un-Necessary operators and so on

##### Statistics: To know where the statistics are is important

##### Query optimizer:

* Computes their CPU, **disk IO cost**, memory requirement
* JOIN, Indexes, Access Path, 

##### Query executor

### Data manager

**Needs to solve: at the same time one query and another modifying & keep data in memory buffers**

##### Cache manager:

* Use buffer pool (in-memory cache)
* The manager needs to get the data in memory before the query executor uses them
* LRU: Least Recently Used (Uses weight)

##### Transaction manager:

* ACID: Atomicity, Isolation, Durability, Consistency

##### Lock Manager:

* exclusive lock
* deadlock
* Two-Phase Locking
* intention lock





