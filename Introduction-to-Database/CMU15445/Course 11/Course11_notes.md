# CMU-15-445: 

## Before this course:
* Required Reading:  <a href=../Resources/数据库系统概念_原书第6版.pdf>Chapter 12.4-12.6</a>

###### 其他运算
* 去重：利用散列或者排序
* 投影
* 集合运算：需要先进行排序之后扫描
* 外连接：1. 计算相应的连接 2. 对于连接算法加以修改
* 聚集：利用散列或者排序

### Papers: 
none

## [In the Course](https://www.youtube.com/watch?v=1D81vXw2T_w&list=PLSE8ODhjZXjbohkNBWQs_otTrBTrjyohi&index=11&ab_channel=CMUDatabaseGroup)

### Join operators
* Join operator: reconstruct the original tuples without any information loss
* Focus on combining two tables at a time with inner equijoin alogrithms
* In general, we want the smaller table to always be the left table(outer table) in the query plan

##### Decision 1: Output
* What data does the join operator emit to its parent operator in the query plan tree?

* 1: Data
  * copy the values for the attributes in outer and inner tuples into a new output tuple
  * Subsequent operators in the query plan never need to go back to the base tables to get more data
  * Because you have send all the data including what you don't need, it may be expensive
* 2: Specific column
  * Only copy the joins keys along with the record ids of the matching tuples
  * Indeal for column stores because the DBMS does not copy data that is not need for the query
  * Called `late materialization`

##### Decision 2: Cost Analysis Criteria
* How do we determine whether one join algorithm is better than another?
* I/O cost analysis

* Assume:
  * M pages in table R, m tuples in R
  * N pages in table S, n tuples in S
* Cost Metric: # of IOs to compute join

##### join vs cross-product
* join is the most common operation and thus must be carefully optimized
* cross-product followed by a selection is inefficient because the cross-product is large
* There are many algorithms for reducing join cost, but no algorithm works well in all scenarios

### Nested Loop Join
##### Simple Loop Join
* For every tuple in R, it scans S once
* Cost: M + (m\*N)
* STUPID
```pseudocode
foreach tuple r ∈ R:      # Outer
  foreach tuple s ∈ S:       # Inner
    emit, if r and s match
```

##### Block Loop Join
* For every block in R, it scans S once
* Cost: M + (M\*N);  Use B-2 buffers for scanning R: M+(M/(B-2)\*N)
* A little better
```pseudocode
foreach block Br ∈ R:
  foreach block Bs ∈ S:
    foreach tuple r ∈ Br:
      foreach tuple s ∈ Bs:
        emit, if r and s match
```

##### Index Loop Join
* WHY do basic nested loop joins sucks:
  * For each tuple in the outer table, we must do a sequential scan to check for a match in the
    inner table
* How to void it:
  * Use an existing index for the join
  * Build one on the fly (hash table, B+Tree)

* Assmue the cost of each index probe is some constant C per tuple
* Cost: M + (m\*C)
```pseudocode
foreach tuple r ∈ R:
  foreach tuple s ∈ Index(ri = sj):
    emit, if r and s match
```


* Pick the smaller table as the outer table
* Buffer as much of the outer table in memory as possible
* Loop over the inner table or use an index

### Sort-Merge Join
* Phase 1: Sort
  * Sort both tables on the join key
  * We can use the external merge sort algorithm that we talked about last class
* Phase 2: Merge
  * Step through the two sorted tables with cursors and emit matching tuples
  * May need to backtrack depending on the join type
* Sort Cost: 2M\*(log M / log B) + 2N\*(log N / log B)
* Merge Cost: (M + N)
```pseudocode
sort R,S on join keys
cursorR <- Rsorted, cursorS <- Ssorted
while cursorR and cursorS:
  if cursorR > cursorS:
    increment cursorS
  if cursorR < cursorS:
    increment cursorR
  elif cursorR and cursorS match:
    emit
    increment cursorS
```
* The worst case for the merging phase is when the join attribute of all of the tuples in both
  relations contain the same value
* Cost: (M\*N) + Cost of sort

##### When to use it
* One or both tables are already sorted on join key
* Output must be sorted on join key
* The input relations may be sorted by either by an explicit sort operator, or by scanning the relation using an index on the join key

### Hash Join
* If tuple r ∈ R and a tuple s ∈ S satisfy the join condition, then they have the same value for the
  join attributes
* If that value is hashed to some partition i, the R tuple must be in r<sub>i</sub> and the S tuple
  in s<sub>i</sub>.
* Therefore, R tuples in r<sub>i</sub> need only to be compared with S tuples in s<sub>i</sub>

* Phase 1: Build
  * Scan the outer relation and populate a hash table using the hash function h<sub>1</sub> on the
    join attributes
* Phase 2: Probe
  * Scan the inner relation and use h<sub>1</sub> on each tuple to jump to a location in the hash
    table and find a matching tuple

```pseudocode
build hash table HTr for R
foreach tuple s ∈ S
  output, if h1(s) ∈ HTr
```

##### Hash function
* Key: The attributes that the query is joining the tables on
* Value: Varies per implementation
  * Depends on what the operators above the join in the query plan expect as its input

* Approach 1: Full Tuple
  * Avoid having to retrieve the outer relation's tuple contents on a match
  * Takes up more space in memory
* Approach 2: Tuple Indentifier
  * Ideal for column stores because the DBMS does not fetch data from disk it does not need
  * Also better if join selectivity is low

###### Optimization
* Bloom Filters
  * Probalistic data structure (bitmap) that answers set membership queries
    * False negatives will never occur
    * False positives can sometimes occur
  * Insert:
    * Use k hash functions to set bits in the filter to 1
  * Lookup:
    * Check whether the bits are 1 for each function

* Create a Bloom Filter during the build phase when the key is likely to not exist in the hash table
  * Threads check the filter before probing the hash table. This will be faster since the filter
    will fit in CPU caches
  * Sometimes called sideways information passing

##### Grace Hash Join
* If we do not have enough memory to fit the entire hash table
  * We do not wnat to let the buffer pool manager swap out the hash table pages at a random.

* Hash join when tables do not fit in memory
  * Build Phase: Hash both tables on the join attribute into partition
  * Probe Phase: Compares tuples in corresponding partitions for each table
* Join each pair of matching buckets between R and S
* Assume that we have enough buffers, Cost: 3(M+N)

```C++
foreach tuple r ∈ bucket<R,0>:
  foreach tuple s ∈ bucket<S,0>:
    emit, if match(r,s)
```

* If the buckets do not fit memory, then use recursive partitioning to split the tables into chunks
  that will fit
  * Build another hash table for bucket\<R,i> using hash function h<sub>2</sub>
  * Then probe it for each tuple of the other table's bucket at that level


* If the DBMS knows the size of the outer table, then it can use a static hash table
  * Less computational overhead for build/probe operations
* If we do not know the size, then we have to use a dynamic hash table or allow for overflow pages

### Conclusion
* Hashing is almost always better than sorting for operator execution
* Caveats:
  * Sorting is better on non-uniform data
  * Sorting is better when result needs to be sorted
* Good DBMSs use either or both

## Exercise
