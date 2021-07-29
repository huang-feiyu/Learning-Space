# CMU-15-445: 

## Before this course:
* Required Reading:  <a href=../Resources/数据库系统概念_原书第6版.pdf>Chapter 12.4-12.5</a>

##### 连接
* 排序: 排序能够提升许多操作的效率，我们使用的是外部归并排序
* 嵌套循环连接
    * 做一个θ连接后去除重复属性
    * 如果一个关系能够全部放在内存，那么把这个关系作为内层关系来处理是有好处的
* 块嵌套循环连接
    * 因缓冲区太小以至于不能完全容纳任何一个关系
    * 以块的形式而不是元组的形式处理关系
* 索引嵌套循环连接
    * 通过已有索引或者建立临时索引查找没满足连接条件的元组
* 归并连接: merge join = sort-merge join
    * 当关系已经排序之后，连接属性上有相同值的元组是连续存放的，连接是高效的
* 散列连接
    * 把两个关系元组分为连接属性值上具有相同散列值的元组集合

### Papers: 
none

## [In the Course](https://www.youtube.com/watch?v=1D81vXw2T_w&list=PLSE8ODhjZXjbohkNBWQs_otTrBTrjyohi&index=10&ab_channel=CMUDatabaseGroup)

#### Query Plan
* High-level instructions
* The operators are arranged in a tree
* Data flows from the leaves of the tree up towards the root
* The output of the root node is the result of the query

#### Disk-Oriented DBMS
* Need a a memory to handle the memory
* Just like it cannot assume that a table fits entirely in memory, a disk-oriented DBMS cannot
  assume that the result of a query fits in the memory
* We are going to use on the buffer pool to implement algorithms that need to spill to disk
* Also going to prefer algorithms that maximize the amount of sequential access

### External Merge Sort
* If data fits in memory, then we can use a standard sorting algorithms like quick-sort
* If data does not fit in memory, then we need to use a technique that is aware of the cost of
  writing data out to disk

* Divide-and-conquer sorting algorithm that splits the data set into separate *runs* and then sorts
  them individually
* Phase 1: Sorting
    * Sort blocks of data that fit in main-memory and then write back the sorted blocks to a file on
      disk
* Phase 2: Merging
    * Combine sorted sub-files into a single larger file

##### 2-Way External merge sort
* 2 represents the number of runs that we are going to merge into a new run for each pass
* Data set is broken up into N pages
* The DBMS has a finite number of B buffer pages to hold input andd output data

* Read every B pages of the table into memory, sort pages into runs and write them back to disk
  (pass 0)
* Recursively merges pairs of runs into runs twice as long, uses three buffer pages(2 for input
  pages, 1 for output page)    (pass 1, 2, 3...)

* Number of passes = 1 + log<sub>2</sub>N
* Total I/O cost = 2N\*(# of passes)

* This algorithm only requires three buffer pages to perform the sorting(B=3)
* But even if we have more buffer space available(B>3), it does not effectively utilize them...

##### Double buffering optimization
* Prefetch the next run in the background and store it in a second buffer while the system is
  processing the current run
    * Reduce the wait time for I/O requests at each step by continuously utilizing the disk

* General K-Way merge sort
    * Pass 0: Use B buffer pages, Produce N/B sorted runs of size B
    * Pass 1,2,3...: Merge B-1 runs
    * Number of passes = 1 + log<sub>B-1</sub>N/B
    * Total I/O cost = 2N\*(# of passes)

##### Using B+Trees for sorting
* If the table that must be sorted already has a B+Tree index on the sort attributes, then we
  can use that to accelerate sorting.
* Retrieve tuples in desired sort order by simply traversing the leaf pages of the tree
* Cases to consider: Clustered OR Unclustered

###### Case 1: Clustered B+Tree
* Traverse to the left-most leaf page, and then retrieve tuples from all leaf pages
* This is always better than external sorting because there is no computational cost and all disk
  access is sequential

###### Case 2: Unclustered B+Tree
* Chase each pointer to the page that contains the data
* This is almost always a bad idea. In general, one I/O per data record.

### Aggregations
* Collapse multiple tuples into a single scalar value.
* Two implementation choices: Sorting & Hashing

##### Sorting aggregation
```SQL
SELECT DISTINCT cid
  from enrolled
WHERE grade IN ('B', 'C')
OEDER BY cid;
```
first filter: Remove columns, then sort
    
* Alternatives to sorting
    * What if we don't need the data totbe ordred?
        * GROUP BY
        * DISTINCT
    * Hashing is better alternatie in this scenario
        * Only need to remove duplicates, no need for ordering
        * Can be computationally cheaper than sorting

##### Hashing aggregation
* Populate an ephemeral hash table as the DBMS scans the table. For each record, check whether there
  is already an entry in the hash table:
    * DISTINCT: Discard duplicate
    * GROUP BY: Perform aggregate computation
* If every fits in memory, then it is easy
* If not, the DBMS must spill data to disk, then we need to be smarter...

* Phase 1: Partiton
    * Divide tuples into buckets based on hash key
    * Write them out to disk when they get full
* Pahse 2: ReHash
    * Build in-memory hash table for each partition and compute the aggregation

* During the ReHAsh phase, store pairs of the form (GroupKey->RunningVal)
* When we want to insert a new tuple into the hash tbale:
    * If we find a matching GroupKey, just update the RunningVal appropriately
    * Else insert a new GroupKey->RunningVal

### Conclusion
* Choice of sorting vs hashing is subtle and depends on optimizations done in each case
* We already discussed the optimizations for sorting:
    * Chunk I/O into large blocks to amortize seek+RD costs
    * Double-buffering to overlap CPU and I/O

## Exercise
