# CMU-154-45: 

## Before this course:

* Required Reading:  <a href=../Resources/数据库系统概念_原书第6版.pdf>Chapter 15.10</a>

### 索引结构中的并发
* 我们所描述的处理B+Tree的技术基于封锁机制，单机不采用两阶段封锁也不采用树形协议

#### crabbing protocol(蟹行协议)
* 先移动一边的腿，然后移动另一边的腿，如此交替进行.
* 在向下的搜索操作中和由于分裂、合并或者重新分布传播向上的操作之间有可能出现死锁
  系统能够很容易处理这种死锁，它先让搜索操作释放锁，然后从树根重启它

* 查找一个key时，蟹行协议首先用共享模式锁住根节点。沿树向下遍历，它在子节点上获得
  一个共享锁，以便向更远处遍历，在子节点上获得锁之后，它释放父节点上的锁，直至叶子节点
* 插入或者删除一个key时
    * 采取与查找相同的协议直至希望的叶子节点，到此为止，只获得和释放共享锁
    * 用排他锁锁住叶子节点，并且插入或者删除key
    * 如果需要分裂节点或者将它与兄弟节点合并，或者在兄弟节点之间重新分配key，蟹行协议
      使用排他锁锁住父节点，在完成这些操作之后，释放该节点和兄弟节点上的锁
          如果父节点需要分裂、合并或者重新分布码值，该协议保留父节点上的锁，以同样的方式
      分裂、合并或者重新分布码值，并且传播更远。否则，该协议释放父结点上的锁。

#### B-link tree locking protocol
* 查找: b+树k的k每一个节点在访问之前必须加共享锁。
    * 非叶子节点上的锁应该在对B+Tree的其他任何节点发出加锁请求前释放。
    * 如果节点分裂和查找同时发生，所希望的搜索码值可能不再位于查找过程中所访问的某个节点所代表的那些值的范围内
      在这种情况下，搜索码值在兄弟节点所代表的范围内，系统循着指向右兄弟节点的指针就能够找到该兄弟节点
    * 封锁遵循两阶段封锁协议
* 插入和删除: 系统遵顼查找规则，定位要进行插入或者删除的叶子节点。将共享锁升级为排他锁
    * 封锁遵循两阶段封锁协议
* 分裂: 如果事务使一个节点分裂，设置原节点和新产生节点的右兄弟指针.
    * 事务释放原节点的排他锁，然后发出对于父节点加排他锁的请求，以便插入指向新节点的指针
* 合并: 一旦两个节点合并，就发出对父节点加排他锁的请求，以便删除要被删除的节点。
    * 此时，事务释放已经合并节点的锁，除非父节点也需要再合并，不然释放锁。

### Papers: 
none

## [In the Course](https://www.youtube.com/watch?v=1D81vXw2T_w&list=PLSE8ODhjZXjbohkNBWQs_otTrBTrjyohi&index=9&ab_channel=CMUDatabaseGroup)

### Observation
* We assumed that all the data structures that we have discussed so far are
  single-threaded
* But we need to allow multiple threds to safely access our data structures
  to take advantage of additional CPU cores and hide disk I/O stalls
* But redis, VOLTDB only use single-thread

#### CONCURRENCY CONTROL
* A concurrency control protocol is the method that the DBMS uses to ensure
  "correct" results for concurrent operations on a shared object
* A protocol's correctness criteria can vary:
    * Logical Correctness: Can I see the data that I am supposed to see
    * **Physical Correctness**: Is the internal representation of the object sound

### Latches Overview

##### Locks VS. Latches
* Locks: Multiple-txns
    * Protects the database's logical contents from other txns
    * Held for txn duration
    * Need to be able to rollback changes
* Latches: Single-txn
    * Protects the critical sections of the DBMS's internal data structure from
      other threads
    * Held for operation duration
    * Do not need to be able to rollback changes
[difference table](./Material/09-indexconcurrency_ppt.pdf)

##### Latch Modes
* Read-read can occur, write-write, write-read cannot occur
* Read Mode
    * Multiple threads can read the same object at the same time
    * A thread can acquire the read latch if another thread has it in read mode
* Write Mode
    * Only one thread can access the object
    * A thread cannot acquire a write latch if another thread holds the latch in
      any mode

##### Latch Implementations
* Approach #1: Blocking OS Mutex
    * Simple to use
    * Non-scalable(about 25ns per lock/unlock invocation)
    * Example: `std::mutex`
```c++
std::mutex m;
// code
m.lock();
// do something special
m.unlock();
```
* Approach #2: Test-and-Set Spin Latch (TAS)
    * Very efficient (single instruction to latch/unlatch)
    * Non-scalable, not cache friendly
    * Example: `std::atomic<T>`
```c++
// std::atomic<bool>
std::atomic_flag latch;
// code
while (latch.test_andset(...)) {
// Retry? Yield? Abort?
}
```
* Approach #3: Reader-Writer Latch
    * Allows for concurrent readers
    * Must manage read/write queues to avoid starvation
    * Can be implemented on top of spinlocks

### Hash Table Latching
* Easy to support concurrent access due to the limited ways threads access the
  data structure
    * All threads move in the same direction and only access a single page/slot
      at a time
    * Deadlocks are not possible
* To resize the table, take a global latch on the entire table(i.e heder page)

##### Approach #1: Page Latches
* Each page has its own reader-write latch that protects its entire contents
* Threads acquire either a read or write latch before they access a page

##### Approach #2: Slot Latches
* Each slot has its own latch
* Can use a single mode latch to reduce meta-data and computational overhead

### B+Tree Latching

##### B+TREE Concurrency Control
* We want to allow multiple threads to read and update a B+Tree at the same time
* We need to protect from two types of problems:
    * Threads trying to modify the contents of a node at the same time
    * One thread traversing the tree while another thread splits/merges nodes

##### Latch Crabbing/Coupling
* Protocol to allow multiple threads to access/modify B+Tree at the same time
* Basic Idea:
    * Get Latch for parent
    * Get Latch for child
    * Release latch for parent if safe
* A safe node is one that will not split or merge when updated
    * Not full
    * More than half-full

* Find: Start at root and go down; repeatedly,
    * Acquire R latch on child
    * Then unlatch parent
* Insert/Delete: Start at root and go down, obtaining W latches as needed.
                 Once child is latched, check if it is safe:
    * If child is safe, release all latches on ancestors

###### Observation
* The very first thing to do: Taking a wirte latch on the root every time
  becomes a bottleneck with higher concurrency
* To do better:
    * Assume that the leaf node is safe
    * Use read latches and crabbing to reach it, and then verify that it is safe
    * If leaf is not safe then do previous algorithm using wirte latches

#### Better Latching Algorithm
* Search: Same as before
* Insert/Delete:
    * Set latches as if for search, get to leaf, and set W latch on leaf
    * If leaf is not safe, releas all latches, and restart thread using previous
      insert/delete protocol with write latches
* This approach optimistically assumes that only leaf node will be modified; if
  not, R latches set on the first pass to leaf are wasteful

##### Observation
* The threads in all the examples so far have acquired latches in a "top-down"
  manner
    * A thread can only acquire a latch from a node that is below its current
      node
    * If the desired latch is unavaliable, the thread must wait until it becomes
      available
* But what if we want to move from one leaf node to another leaf node?

### LeafNode Scans(scale search)
* DEAD_LOCK could occur

* Latches do not support deadlock detection or avoidance. The only way we can
  deal with this problem is through coding discipline
* The leaf node sibling latch acquisition protocol must support a "no-wait" mode
* The DBMS's data structures must cope with failed latch acquisitions

### Delayed parent Updates
* Every time a leaf node overlows, we must update at least three nodes
    * The leaf node being split 
    * The new leaf node being created
    * The parent node
* B-link tree Optimization: When a leaf node overflows, delay updating its
  parent node

### Conclusion
* Making a data structure thread-safe is notoriously difficult in practice
* We focused on B+Tree but the same high-level techniques are applicable to
  other data structures

## Exercise

