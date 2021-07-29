# CMU-154-45: 

## Before this course:

* Required Reading:  <a href=../Resources/数据库系统概念_原书第6版.pdf>Chapter 10.5-10.8</a>

### Papers: 

#### [NEW Five minute rule](./Material/Buffer_Management/The_five_minute_rule_20_years_later_and_how_flash_memory_changes_the_rules.pdf)

*  The characteristics of flash  memory suggest some substantial differences in the management of  B-tree pages and their allocation.
* Page: 4KB ~ 256KB

**A Paper about page and its storage model.**



#### [Managing NVM in database](./Material/Buffer_Management/Managing_Non-Volatile_memory_in_database_systems.pdf)

* DRAM: Dynamic random access memory
* NVM: Non-volatile memory (alias: SCM: storage class memory & NVRAM)
  * combine the performance and byte addressability of DRAM with the persistence of traditional storage devices like flash

* Two approach to use NVM
  * store all data and index structures on it, less efficient than main-memory database system
  * use a page-based DRAM cache in front of NVM, does not utilize the byte addressability of NVM: accessing an un-cached tuple on NVM requires retrieving an entire page

**the capacity of NVM is limited compared to SSDs**



*  To leverage the byte-addressability of NVM, we cache NVM accesses in DRAM at cache-line granularity, which allows for the selective loading of individual hot cache lines instead of entire pages (which might contain mostly cold data). 
*  To more efficiently use the limited DRAM cache, our buffer pool transparently and adaptively uses small page sizes. 
*  At the same time, our design also uses large page sizes for staging data to SSD—thus enabling very large data sets. 
* We use lightweight buffer management techniques to reduce the overhead of in-memory accesses. 
*  Updates are performed in main memory rather than directly on NVM, which increases endurance and hides write latency.

## [In the Course](https://www.youtube.com/watch?v=1D81vXw2T_w&list=PLSE8ODhjZXjbohkNBWQs_otTrBTrjyohi&index=5&ab_channel=CMUDatabaseGroup)

#### Review
* OLTP: On-line transaction Processing, Fast operations that only read/update a
  small amount of data each time
* OLAP: On-line Analytical Processing, Compleax queries that read a lot of data
  to compute aggreagates
* HTAP: Hybrid Transaction + Analytical Processing: OLTP+OLAP in the same
  database instance
* ETL: Extract Transform Load   
* OLTP Data Silos ===ETL===> OLAP data warehouse

**To finad how the DBMS manages its memory and move data back-and-forth from
disk**

### Database storage
* Spatial Control:
    Where to write pages on disk, the goal is to keep pages that are used
    together often as physically close together as possible on disk
* Temporal Control: 
    When to read pages into memory, and when to write them to disk
    The goal is minimize the number of stalls from having read data from disk
* DISK => Buffer Pool(in memory)

### Buffer Pool manager

#### Buffer Pool organization
* Memory region organized as an array of fixed-size pages, an array entry is
  called a frame
* When the DBMS requests a page, an exact copy is placed into one of these
  frames  

#### Buffer Poll meta-data
Hash table
* Page table keeps track of pages that are currently in memory
* Also maintains additional meta-data per page: Dirty Flag(Whether the page is
  modified), Pin/Reference Counter(To count how many times the page has been
  visited, to remain the page in the buffer pool)

#### Locks vs. Latches
* Locks: **Latch**
    * Protects the database's logical contents from other transactions
    * held for transaction duration
    * need to be able to rollback changes
* Latches: **Mutex**
    * Protects the critical sections of the DBMS's internal data structure from
      other thread
    * Held for operation duration
    * Do not need to be able to rollback changes

#### Page table vs. page directory
* Page Directory:
    * Mapping from page ids to page locations in the database files
    * All changes must be recorded on disk toa llow the DBMS to find on restart
* Page Table: (in memory)
    * mapping page ids to a copy of the page in buffer pool frames
    * in memory data structure that does not need to be stored in disk

#### Allocation policies
* Global Policies: make decisions for all active txns(Transactions)
* Local Policies: 
    * allocate frames to a specific txn without considering the behavior of
      concurren txns
    * Still need to support sharing pages

#### Buffer pool optimizations
* Multiple buffer pools: Helps reduce latch contention and improve locality
    * Object Id: embed an object identifier inrecord ids and then maintain a
      mapping from objects to specific buffer pools
    * Hashing: Hash the page id to select which buffer pool to access
* Pre-fetching: based on a quey plan(sequential scan or index scans)
* Scan sharing: Queries can reuse data retrieved from storage or operator
  computation
    * Allow multiple queries to attach to a single cursor that scans a table
* Buffer pool bypass: Sequential scan operator will not store fetched pages in
  the buffer pool to avoid overhead
    * Memory is loacl to running query
    * works well if operator needs to read a large sequence of pages that are
      contiguous on disk
    * can also be used for temporary data(Sort, join)

#### OS Page CACHE
* Most disk operations go through the OS API
* Unless you tell it not to, the OS maintains its own filesystem cache
* Most DBMSs use direct I/O(O_DIRECT) to bypass the OS'cache
    * Redundant copies of pages
    * Different eviction policies

### Replacement Policies
* When DBMS needs to free up a frame to make room for a new page, it must decide
  which page to evict from the buffer pool
* Goals:
    * Correctness
    * Accuracy
    * Speed
    * Meta-data overhead
#### LRU: Least-Recently used
* maintain a timestamp of when each page was last accessed
* When the DBMS needs to evict a page, select the one with the oldest timestamp
    * Keep the pages in sorted order to reduce the search time on eviction

##### CLOCK
* Approximation of LRU without needing a separate timestamp per page
    * Each page has a reference bit
    * When a page is accessed, set to 1
* Organize the pages in a circular buffer with a "clock hand"
    * Upon sweeping, chech if a page;s bit is set to 1
    * If yes, set to zero. If no, then evict

##### Problems
* LRU and CLOCK replacement policies are susceptibale to sequential flooding
    * A query performs a sequential scan that reads every page
    * This pollutes the buffer pool with pages that are read once and then never
      again
* The most recently used page is actually the most unneeded page

#### LRU-K
* Track the history of last K reference to each page as timestamps and compute
  the interval between subsequent accesses
* The DBMS then uses this history to estimate the next time that page is going
  to be accessed

#### LOCALIZATION
* The DBMS chooses which pages to evict on a per txn/query basis
    * Minimizes the pollution of the buffer pool from each query
    * Keep track of the pages that a query has accessed
                                                                                     
#### PRIORIY HITS
* DBMS knows what the context of each page during query execution
* It can provide hints to the buffer pool on whether a page is important or not

#### Dirty Pages
**Dirty page is the page that has been modified by DBMS**
* FAST: If a page in the buffer pool is not dirty, then the DBMS can simply drop
  it
* SLOW: If a page is dirty, then the DBMS must write back to disk to ensure that
  its changes are persisted
* Trade-off between fast evictions versus dirty writing pages that will not be read
  again in the future

##### BACKGROUND WRITING 
* THE DBMS can periodically walk through the page table and write dirty pages to
  disk
* When a dirty page is safely written, the DBMS can either evict the page or
  just unset the dirty flag
* Need to be careful that we don't write dirty pages before their log records
  have been written

### Other Memory Pools
THe DBMS needs tmemory for things other than just tuples and indexes.

These memory pools may not always backed by disk. Depends on implementation:
* Sorting + Join Buffers
* Query Caches
* Maintenance Buffers
* Log Buffers
* Dictionary Caches

### Conclusion
* THe DBMS can manage that sweet, sweet memory better than the OS
* Leverage the semantics about the query plan to make better decisions:
    * Evictions
    * Allocations
    * Pre-fetching

## Exercise

### Project#1
* Build the first component of storage manager
    * Clock Replacement Policy
    * Buffer Pool Manager

#### TASK#1 - CLOCK REPLACEMENT POLICY
* Build a data structure that tracks the usage of `frame_ids` using the CLOCK
  policy
* General Hints:
    * `ClockReplacer` needs to check the "pinned" status of a Page
    * If there are no pages touched since last sweep, then return the lowest
      page id

#### TASK#2 - BUFFER POOL MANAGER
* Use CLOCK replacer to manage the allocation of pages
    * need to maintain an internal data structures of allocated + free pages
    * Use whatever data structure you want for the page table
* General Hints:
    * Make sure get the order of operations correct when pinning

##### CODE QUALITY
* Google C++ Style Guide
* Doxygen Javadoc Style

