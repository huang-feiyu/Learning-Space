# CMU-15-445: 

## Before this course:
* Required Reading:  <a href=../Resources/数据库系统概念_原书第6版.pdf>Chapter 12.1-12.3 & 12.7</a>

#### 查询处理
* 查询基本步骤：
  * 语法分析和翻译: 将SQL语言翻译为关系代数式
    * (evaluation primitive)计算原语: 加入了注释(说明如何执行操作, 利用什么算法)的关系代数运算
  * 优化
  * 执行: 反馈查询结果
    * 查询执行引擎(query-execution engine)接受一个查询执行计划(query-execution plan)，执行计划并且返回给查询

* 查询代价的度量：
  * 对于**磁盘存取**、执行一个查询所用CPU时间，还有在并行/分布式数据库系统中的通信代价
  * 通过额外的资源消耗为代价，计划可能获得更好的响应时间
  * 通过度量查询代价，优化器通常努力去尽可能降低查询计划总的资源消耗，而不是尽可能减少响应时间
* 选择运算：
  * 使用文件扫描和索引的选择：
    * 线性选择：系统扫描每一个文件块，对所有记录都进行测试，看它们上是否满足选择条件。
    * 索引结构称为存取路径，因为提供了定位和存取数据的一条路径。
    * 主索引，key属性等值比较：通过索引检索到满足相应等值条件的唯一一条记录。
    * 主索引，非key属性等值比较：通过索引可以检测到多条满足等值条件的记录，这些记录在文件中是连续存储的。
    * 辅助索引，等值比较：根据是否为key属性选择不同的做法。
  * 涉及比较的选择：
    * 主索引，比较：顺序主索引比较
    * 辅助索引，比较：有序辅助索引比较，提供了指向记录的指针，可能连续的记录存在于不同的磁盘块中
  * 复杂选择的实现：
    * 合取(conjunctive seleciton), 析取(disjunctive selection), 取反
    * 利用一个索引的合取选择：判断是否存在某个属性上的一条存储路径，如果存在，可以使用前述的方法
    * 利用组合索引的合取选择：通过组合索引(composite index，在多个属性上建立的一个索引)，利用前述方法
    * 通过标识符的交实现合取选择：要求使用指针
    * 通过标识符的并实现析取操作：使用指针

#### 表达式计算

一种显而易见的方法是以适当的顺序每次执行一个操作，每次的结果被物化(materialized)到一个临时关系中以备后用——缺点是需要构造临时关系，这些临时关系必须写到磁盘上。

* 物化(materialized)：建立临时关系作为输入执行投影，可以得到最终的结果。双缓存(double buffering)(一个用于连续执行算法，另一个用于写出结果)允许CPU活动和I/O活动并行，提高算法执行速度。

* 流水线计算(pipelined evaluation)：消除读写临时关系的代价，减少查询计算代价；迅速产生查询结果
  * 通过将所有操作组合起来构成流水线，构造一个单独的复合操作

* demand-driven pipeline需求驱动的流水线：
  * 迭代算子(iterator)
* producer-driven pipeline生产者驱动的流水线
  *   对于每对相邻的操作，系统会创建一个缓冲区来保存从一个操作传递到下一个的元组。不同操作的进程或线程并发执行。

* 流水线的执行算法：有序的输入可以使用归并连接，无序的一般使用双流水线连接技术(double-pipeline join)——使用双流水线散列连接(double-pipeline hash-join)

```pseudocode
done-r: = false;
done-s: = false;
r := Θ；
s := Θ;
result := Θ;
while not done-r or not done-s do
	begin
		if queue is null, then wait till queue is not null
		t := first one of the queue;
		if t = End-r 
			then done-s := true
		else if t = End-s 
			then done-s := true
		else if t ∈ r
        	then 
        		begin
        			r := r ∪ {t};
        			result := reslut ∪ ({t} join s);
        		end
        else if t ∈ s
        	then
        		begin 
        		    s := s ∪ {t};
        			result := reslut ∪ ({s} join s);
        		end
     end   		
```




### Papers: 
none

## [In the Course](https://www.youtube.com/watch?v=1D81vXw2T_w&list=PLSE8ODhjZXjbohkNBWQs_otTrBTrjyohi&index=12&ab_channel=CMUDatabaseGroup)

### Procssing Models
* A DBMS's processing model defines how the system executes  a query plan.
* Different trade-offs for different workloads

##### Iterator Model
* Each query plan operator implements a `Next` function.
  * On each invocation, the operator returns either a single tuple or a null marker if there are no more tuples
  * The operator implements a loop that calls next on its children to retrieve their tuples and then process them

* This is used in almost every DBMS. Allows for tuple pipelining.
* Some operators have to block until their children emit all of their tuples.
  * Joins, Subqueries, Order By
* Output control works easily within this approach.

##### Materialization Model
* Each operator processing its input all at once and then emits its output all at once.
  * The operator "materializes" its output as a single result.
  * The DBMS can push down hints into to avoid scanning too many tuples.
  * Can send either a materialized row or single column
* The output can be either whold tuples (NSM) or subsets of columns (DSM).

* Better for OLTP workloads because queries only access a small number of tuples at a time.
  * Lower execution / coordination overhead
  * Fewer function calls
* Not good for OLAP queries with large intermediate result.

##### Vectorized/Batch Model
* Like the Iterator Model where each operator implements a `Next` function in this model.
* Each operator emits a batch of tuples instead of single tuple.
  * The operator's internal loop processes multiple tuples at a time
  * The size of the batch can vary based on hardware or query properties

* Indeal for OLAP queries because it greatly reduces the number of invocations per operator.
* Allows for operators to use vectorized (SIMD) instructions to process batches of tuples.

##### Plan Processing Direction
* Top-to-Bottom
  * Start with the root and "pull" data up from its children
  * Tuples are always passed with function calls
* Bottom-to-Top
  * Start with leaf nodes and push data to their parents
  * Allows for tighter control of caches/registers in pipelines

### Access Methods
* An access method is a way that the DBMS can access the data stored in a table
  * Not defined in relational algebra

##### Sequential scan
* For each page in the table:
  * Retrieve it from the buffer pool
  * Iterate over each tuple and check whether to include it
* The DBMS maintains an internal cursor that tracks the last page/slot it examined

* This is almost always the worst thing that the DBMS can do to execute a query.
* Optimizations:
  * Prefetching
  * Buffer Pool Bypass
  * Parallelization
  * **Zone Maps**
    * Pre-computed aggregates for the attribute values in a page. DBMS checks the zone map first to
      decide whether it wants to access the page.
  * **Late Materialization**
    * DSM DBMSs can delay stitching together tuples until the uper parts of the query plan.
  * **Heap Clustering**
    * Tuples are sorted in the heap's pages using the order specified by a clustering index
    * If the query accesses tuples using the clustering index's attributes, then the DBMS can jump directly to the pages that it needs.

##### Index Scan
* The DBMS picks an index to find the tuples that the query needs
* Which index to use depends on:
  * What attributes the index contains
  * What attributes the query references
  * The attribute's value domains
  * Predicate composition
  * Whether the index has unique or non-unique keys

##### Multi-Index Scan (Bitmap Scan)
* If there are multiple indexes that the DBMS can use for a query:
  * Compute sets of record ids using each matching index
  * Combine these sets based on the query's predicates (union vs. intersect)
  * Retrieve the records and apply any remaining predicates

(Set intersection can be done with bitmaps, hash tables, or Bloom filters)

##### Index scan page sorting
* Retrieving tuples in the order that appear in an unclustered index is inefficieng
* The DBMS can first figure out all the tuples that it needs and then sort them based on their page id.

### Expression Evaluation
* The DBMS represents a `WHERE` clauseas an expression tree.
* The nodes in the tree represents different expression types:
  * Comparsions
  * Conjunction, Disjunction
  * Arithmetic Operators
  * Constant Values
  * Tuple Attribute References
* Evaluating predicates in this manner is slow.
  * The DBMS traverses the tree and for each node that it visits it must figure out what the
    operator needs to do
    * Consider the predicate `WHERE 1=1`
* A better approach is to just evaluate teh expression directly
  * Think JIT compilation

### Conclusion
* The same query plan be executed in multiple ways
* (Most) DBMSs will want to use an index scan as much as possible
* Expression trees are flexible but slow

## Exercise
