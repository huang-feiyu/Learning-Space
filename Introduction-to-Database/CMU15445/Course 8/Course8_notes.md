# CMU-154-45: 

## Before this course:

* Required Reading:  <a href=../Resources/数据库系统概念_原书第6版.pdf>Chapter 11.1-11.4</a>

[My Blog About B+Tree](https://huang-feiyu.github.io/2021/05/09/B-Plus-Tree/)

### Papers: 

#### [The Ubiquitous B-tree](./Material/The_Ubiquitous_B-tree.pdf)

##### B<sup>+</sup>-Trees
* all keys reside in the leaves
* upper levels: organized as a B-tree, consist only of an index, a roadmap to
  enable rapid location of the index and key parts
* logical separation of the index and key parts
* (linked list of leaves )leaf nodes are usually linked together left-to right
* To fully appreciate a B+Tree, one must understand the implications of having
  an independent index and sequence set
* Search:
    * Since all keys reside in the leaves, it does not matter what values are
      encountered as the search progresses as long as the path leads to the
      correct leaf
* Deletion:
    * The key to be deleted must always reside in a leaf so its removal is
      simple(ass long as the leaf remains at least half full)
    * Deleted key's duplicate in the index node can be maintained
* Insertion:
    * when a leaf splits in two, instead of promoting the middle key, the
      algorithm promotes a copy of the key, retaining the actually key in the
      right leaf

##### Optimization
* Prefix B+Trees
* Virtual B-Trees: Demand Paging
    * Each node of B-trees can be mapped into one page of the virtual address
      space
    * Treats B-tree as if it were in memory(secondary storage)
    * LRU algorithm
* Compression:
* Variable Length Entries
* Binary B-Trees
* 2-3 Trees and Theoretical Results


## [In the Course](https://www.youtube.com/watch?v=1D81vXw2T_w&list=PLSE8ODhjZXjbohkNBWQs_otTrBTrjyohi&index=8&ab_channel=CMUDatabaseGroup)

### More B+Trees

##### Duplicate Keys
* Append Record Id: <Key,Record-Id> => no duplicate
    * add the tuple's unique record id(page id, offset, etc.) as part of the key
      to ensure that all keys are unique
    * The DBMS can still use partial keys to find tuples
* Overflow Leaf-Nodes: overflow list may be unsorted
    * Allow leaf nodes to spill into overflow nodes that contain the duplicate
      keys
    * This is more complex to maintain and modify

### Additional Index Magic

##### Implicit Indexes
* Most DBMSs automatically create an index to enforce integrity constraints but
  not referential constraints(foreign keys)
    * Primary Keys, MySQL
    * Unique Constraints, Postgress

##### Partial Indexes
* Create an index on a subset of the entire table.
* One common use case is to partition indexes by date ranges
    * Create a separate index per month, year

##### Covering indexes
* If all the fields needed to process the query are available in an index,
  then the DBMS does not need to retrieve the tuple
* This reduces contention on the DBMS's buffer pool resources

##### Index include columns
* Embed additional columns in indexes to support index-only queries
* These extra columns are only stored in the leaf nodes and are not part of the
  search key

##### Functional/Expression Index
* An index does not need to store keys in the same way that they appear in their
  base table
* You can use expressions when declaring an index

### Tries/Radix Trees

##### OBSERVATION
* The inner node keys in a B+Tree cannot tell you whether a key exists in the
  index. You must always traverse to the leaf node.
* This means you could have(at least) one buffer pool page miss per level in the
  tree just to  find out a key does not exist

##### Tries: 字典树,单词查找树 
* Use a digital representation of keys to examine prefixes one-by-one instead of
  comparing entire key
* Also know as Digital Search Tree, Prefix Tree
* Shape only depends on key space and lengths
    * Does not depend on existing keys or insertion order
    * Does not require rebalancing operations
* All operations have O(k) complexity where k is the length of the key
    * The path to a leaf node represents the key of the leaf
    * Keys are stored implicitly and can be reconstructed from paths
* Tries key span
    * The span of a tries level is the number of bits that each partial key/digit
      represents
        * If the digit exists in the corpus, then store a pointer to the next
          level in the tries branch. Otherwise, store null
    * This determines the fan-out of each node and the physical height of the
      tree.
        * n-way Tries = Fan-Out of n

##### Radix Tree(基数树)
* Subset of Tries
* Omit all nodes with only a single child
    * Also known as Patricia Tree
* Can produce false positives, so the DBMS always checks the original tuple to
  see whether a key matches
* Modifications: There is no standard way to modify it

### Inverted Indexes(反向索引)

##### Observation
* The tree indexes that we're discussed so far are useful for "point" and "range" queries
    * Find all customers in the 15217 zip code
    * Find all orders between June 2018 and September 2018
* They are not good at keyword searches:
    * Find all Wikipedia articles that contain the word "Huang"

##### Inverted Index
* An inverted index stores a mapping of words to records that contain those
  words in the target attribute
    * Sometimes called a full-text search index
    * Also called a concordance in old times
* The major DBMSs support these natively
* There are also specialized DBMSs

##### Query Types
* Phrase Searches
    * Find records that contain a list of words in the given order
* Proximity Searches
    * Find records where two words occur within n words of each other
* Wildcard Searches
    * Find records that contain words that match some patterns

##### Design Decision
* What to store
    * The index needs to store at least the words contained in each record
    * Can also store frequency, position, and other meta-data
* When to update
    * Maintain auxiliary data structures to "stage" updates and then update the
      index in batches

### Conclusion
* B+Tree are still the way to go for tree indexes

## Exercise

