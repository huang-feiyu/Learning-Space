## [B<sup>+</sup> Tree](https://15445.courses.cs.cmu.edu/fall2020/project2/)

You will need to implement [B+Tree](https://en.wikipedia.org/wiki/B%2B_tree) dynamic index structure. It is a balanced tree in which the internal pages direct the search and leaf pages contains actual data entries. Since the tree structure grows and shrink dynamically, you are required to handle the logic of split and merge. The project is comprised of the following tasks and it has two checkpoints.

### CHECKPOINT #1

#### TASK#1-B<sup>+</sup> Tree Pages

##### B<sup>+</sup> Tree Parent Page

###### Definition

This is the parent class that both the Internal Page and Leaf Page inherited from and it only contains information that both child classes share.

###### Location

`src/include/storage/page/b_plus_tree_page.h` `src/page/b_plus_tree_page.cpp`

###### B+Tree Parent Page Content

| Variable Name   | Size | Description                             |
| --------------- | ---- | --------------------------------------- |
| page_type_      | 4    | Page Type (internal or leaf)            |
| lsn_            | 4    | Log sequence number (Used in Project 4) |
| size_           | 4    | Number of Key & Value pairs in page     |
| max_size_       | 4    | Max number of Key & Value pairs in page |
| parent_page_id_ | 4    | Parent Page Id                          |
| page_id_        | 4    | Self Page Id                            |

##### B<sup>+</sup> Tree INTERNAL PAGE

###### Definition

Internal Page does not store any real data, but instead it stores an ordered **m** key entries and **m+1** child pointers (a.k.a page_id). Since the number of pointer does not equal to the number of key, the first key is set to be invalid, and lookup methods should always start with the second key. At any time, each internal page is at least half full. During deletion, two half-full pages can be joined to make a legal one or can be redistributed to avoid merging, while during insertion one full page can be split into two.

###### Location

`src/include/storage/page/b_plus_tree_internal_page.h` 

 `src/page/b_plus_tree_internal_page.cpp`

##### B<sup>+</sup> Tree LEAF PAGE

###### Definition

The Leaf Page stores an ordered **m** key entries and **m** value entries. In your implementation, value should only be 64-bit record_id that is used to locate where actual tuples are stored, see `RID` class defined under in `src/include/common/rid.h`. Leaf pages have the same restriction on the number of key/value pairs as Internal pages, and should follow the same operations of merge, redistribute and split.

###### Location

`src/include/storage/page/b_plus_tree_leaf_page.h`) `src/storage/page/b_plus_tree_leaf_page.cpp`

###### Others

Even though the Leaf Pages and Internal Pages contain the same type of key, they may have distinct type of value, thus the `max_size` of leaf and internal pages could be different.

Each B+Tree leaf/internal page corresponds to the content (i.e., the `data_` part) of a memory page fetched by buffer pool. So every time you try to read or write a leaf/internal page, you need to first **fetch** the page from buffer pool using its unique `page_id`, then [reinterpret cast ](http://en.cppreference.com/w/cpp/language/reinterpret_cast)to either a leaf or an internal page, and unpin the page after any writing or reading operations.

#### TASK#2.A - B<sup>+</sup>Tree Data Structure (INSERTION & POINT SEARCH)

###### Definition

Your B+Tree Index could only support **unique key**. That is to say, when you try to insert a key-value pair with duplicate key into the index, it should not perform the insertion and return false.

For Checkpoint #1, your B+Tree Index is only required to support **insertions** (`Insert`) and **point search** (`GetValue`). You do **NOT** needs to implement deletions for Checkpoint #1. However, you should correctly perform split if insertion triggers current number of key/value pairs after insertion equals to `max_size`. Since any write operation could lead to the change of `root_page_id` in B+Tree index, it is your responsibility to update `root_page_id` in the header page (`src/include/storage/page/header_page.h`) to ensure that the index is durable on disk. Within the `BPlusTree` class, we have already implemented a function called `UpdateRootPageId` for you; all you need to do is invoke this function whenever the `root_page_id` of B+Tree index changes.

###### Content

```c++
// must hide the details of key|value type and associated comparator
template <typename KeyType,
          typename ValueType,
          typename KeyComparator>
class BPlusTree{
   // ---
};
```

###### Other

These classes are already implemented for you:

- `KeyType`: The type of each key in the index. This will only be `GenericKey`, the actual size of `GenericKey` is specified and instantiated with a template argument and depends on the data type of indexed attribute.
- `ValueType`: The type of each value in the index. This will only be 64-bit RID.
- `KeyComparator`: The class used to compare whether two `KeyType` instances are less/greater-than each other. These will be included in the `KeyType` implementation files.

### CHECKPOINT#2

#### TASK#2.B - B<sup>+</sup> Tree DATA STRUCTURE (DELETION)

Your B+Tree Index is required to support deletions. Your B+Tree Index should correctly perform merge or redistribute if deletion cause certain page to go below the occupancy threshold. Again, your B+Tree Index could only support unique key and you should follow the same guidelines in **Task #2.a**.

#### TASK#3 - INDEX ITERATOR

###### Definition

You will build a general purpose index iterator to retrieve all the leaf pages efficiently. The basic idea is to organize them into a single linked list, and then traverse every key/value pairs in specific direction stored within the B+Tree leaf pages. Your index iterator should follow the functionality of [Iterator](http://www.cplusplus.com/reference/iterator/) defined in C++17, including the ability to iterate through a range of elements using a set of operators, and for-each loop (with at least the increment, dereference, equal and not-equal operators). Note that in order to support for-each loop function for your index, your `BPlusTree` should correctly implements `begin()` and `end()`.

###### Location

`src/include/storage/index/index_iterator.h`    `src/index/storage/index_iterator.cpp`

###### Content

- `isEnd()`: Return whether this iterator is pointing at the last key/value pair.
- `operator++()`: Move to the next key/value pair.
- `operator*()`: Return the key/value pair this iterator is currently pointing at.
- `operator==()`: Return whether two iterators are equal
- `operator!=()`: Return whether two iterators are not equal.

#### TASK#4 - CONCURRENT  INDEX

###### Definition

In this part, you need to update your original single-threaded B+Tree index so that it can support concurrent operations. We will use the latch crabbing technique described in class and in the textbook. The thread traversing the index will acquire then release latches on B+Tree pages. A thread can **only** release latch on a parent page if its child page considered "safe". Note that the definition of "safe" can vary based on what kind of operation the thread is executing:

###### Content

- `Search`: Starting with root page, grab read (**R**) latch on child Then release latch on parent as soon as you land on the child page.
- `Insert`: Starting with root page, grab write (**W**) latch on child. Once child is locked, check if it is safe, in this case, not full. If child is safe, release **all** locks on ancestors.
- `Delete`: Starting with root page, grab write (**W**) latch on child. Once child is locked, check if it is safe, in this case, at least half-full. (NOTE: for root page, we need to check with different standards) If child is safe, release **all** locks on ancestors.

###### Other

The write up only describe the basic concepts behind latch crabbing, before you start your implementation, please consult with lecture and textbook Chapter 15.10.

###### Requirements and Hints

- You are **not** allowed to use a global scope latch to protect your data structure. In other words, you may not lock the whole index and only unlock the latch when operations are done. We will check grammatically and manually to make sure you are doing the latch crabbing in the right way.
- We have provided the implementation of read-write latch (`src/include/common/rwlatch.h`). And have already added helper functions under page header file to acquire and release latch (`src/include/storage/page/page.h`).
- We will not add any **mandatory** interfaces in the B+Tree index. You can write any private/helper functions in your implementation as long as you keep all the original public interfaces intact for test purpose.
- For this task, you have to use the passed in pointer parameter called `transaction` (`src/include/concurrency/transaction.h`). It provides methods to store the page on which you have acquired latch while traversing through B+ tree and also methods to store the page which you have deleted during `Remove` operation. Our suggestion is to look closely at the `FindLeafPage` method within B+ tree, you may wanna modify your previous implementation (note that you may need to change to **return value** for this method) and then add the logic of latch crabbing within this particular method.
- The return value for FetchPage() in buffer pool manager is a pointer that points to a Page instance (`src/include/storage/page/page.h`). You can grab a latch on `Page`, but you cannot grab a latch on B+Tree node (neither internal node nor leaf node).

###### Common Pitfalls

- You are NOT tested for thread-safe scans in this project (no concurrent iterator operations will be tested). However, a correct implementation would requires the Leaf Page to throw an `std::exception` when it cannot acquire a latch on its sibling to avoid potential dead-locks.
- Think carefully about the order and relationship between `UnpinPage(page_id, is_dirty)` method from buffer pool manager class and `UnLock()` methods from page class. You have to release the latch on that page **BEFORE** you unpin the same page from the buffer pool.
- If you are implementing concurrent B+tree index correctly, then every thread will **ALWAYS** acquire latch from root to bottom. When you release the latch, make sure you follow the same order (a.k.a from root to bottom) to avoid possible deadlock situation.
- One of the corner case is that when insert and delete, the member variable **root_page_id** (`src/include/storage/index/b_plus_tree.h`) will also be updated. It is your responsibility to protect from concurrent update of this shared variable(hint: add an abstract layer in B+ tree index, you can use `std::mutex` to protect this variable)

## [HASH INDEX](https://15445.courses.cs.cmu.edu/fall2019/project2/)

#### TASK #1 - PAGE LAYOUTS

Your hash table is meant to be accessed through the DBMS's `BufferPoolManager`. This means that you cannot allocate memory to store information. Everything must be stored in disk pages so that they can read/written from the `DiskManager`. If you create a hash table, write its pages to disk, and then restart the DBMS, you should be able to load back the hash table from disk after restarting.

To support reading/writing hash table blocks on top of pages, you will implement two `Page` classes to store the data of your hash table. This is meant to teach you how to allocate memory from the `BufferPoolManager` as pages.

- [**Hash Table Header Page**](https://15445.courses.cs.cmu.edu/fall2019/project2/#hash-table-header-page)
- [**Hash Table Block Page**](https://15445.courses.cs.cmu.edu/fall2019/project2/#hash-table-block-page)

##### HASH TABLE HEADER PAGE

This class holds all of the meta-data for the hash table. It is divided into the fields as shown by the table below:

| **Variable Name** | **Size**   | **Description**                                        |
| ----------------- | ---------- | ------------------------------------------------------ |
| `page_id_`        | 4 bytes    | Self Page Id                                           |
| `size_`           | 4 bytes    | Number of Key & Value pairs the hash table can hold    |
| `next_ind_`       | 4 bytes    | The next index to add a new entry to `block_page_ids_` |
| `lsn_`            | 4 bytes    | Log sequence number (Used in Project 4)                |
| `block_page_ids_` | 4080 bytes | Array of block `page_id_t`                             |

The `block_page_ids_` array maps block ids to `page_id_t` ids. The ith element in `block_page_ids_` is the `page_id` for the ith block.

You must implement your Hash Table Header Page in the designated files. You are only allowed to modify the header file (`src/include/page/hash_table_header_page.h`) and its corresponding source file (`src/page/hash_table_header_page.cpp`).

##### HASH TABLE BLOCK PAGE

The Hash Table Block Page holds three arrays:

- `occupied_` : The ith bit of `occupied_` is 1 if the ith index of `array_` has ever been occupied.
- `readable_` : The ith bit of `readable_` is 1 if the ith index of `array_` holds a readable value.
- `array_` : The array that holds the key-value pairs.



The number of slots available in a Hash Table Block Page depends on the types of the keys and values being stored. You only need to support fixed-length keys and values. The size of keys/values will be the same within a single hash table instance, but you cannot assume that they will be the same for all instances (e.g., hash table #1 can have 32-bit keys and hash table #2 can have 64-bit keys).

You must implement your Hash Table Block Page in the designated files. You are only allowed to modify the header file (`src/include/page/hash_table_block_page.h`) and its corresponding source file (`src/page/hash_table_block_page.cpp`).

Each Hash Table Header/Block page corresponds to the content (i.e., the byte array `data_`) of a memory page fetched by buffer pool. Every time you try to read or write a page, you need to first fetch the page from buffer pool using its unique `page_id`, then reinterpret cast to either a header or a block page, and unpin the page after any writing or reading operations.

#### TASK #2 - HASH TABLE IMPLEMENTATION

You will implement a hash table that uses the linear probing hashing scheme. It needs to support insertions (`Insert`), point search (`GetValue`), and deletions (`Remove`).

Your hash table must support both unique and non-unique keys. Duplicate values for the same key are not allowed. This means that `(key_0, value_0)` and `(key_0, value_1)` can exist in the same hash table, but not `(key_0, value_0)` and `(key_0, value_0)`. The `Insert` method only returns false if it tries to insert an existing key-value pair.

Your hash table implementation must hide the details of the key/value type and associated comparator, like this:

```C++
template <typename KeyType,
          typename ValueType,
          typename KeyComparator>
class LinearProbeHashTable {
   // ---
};
```

These classes are already implemented for you:

- `KeyType`: The type of each key in the hash table. This will only be GenericKey, the actual size of GenericKey is specified and instantiated with a template argument and depends on the data type of indexed attribute.
- `ValueType`: The type of each value in the hash table. This will only be 64-bit RID.
- `KeyComparator`: The class used to compare whether two KeyType instances are less/greater-than each other. These will be included in the KeyType implementation files.



Note that, to compare whether two ValueType instances are equal to each other, you can use the == operator.

##### TASK #3 - TABLE RESIZING

The linear probing hashing scheme uses a fized-size table. When the hash table is full, then any insert operation will get stuck in an infinite loop because the system will walk through the entire slot array and not find a free space. If your hash table detects that it is full, then it must resize itself to be twice the current size (i.e., if currently has n slots, then the new size will be 2×n).

Since any write operation could lead to a change of `header_page_id` in your hash table, it is your responsibility to update `header_page_id` in the header page (`src/include/page/header_page.h`) to ensure that the container is durable on disk.

#### TASK #4 - CONCURRENCY CONTROL

Up to this this point you could assume that your hash table only supported single-threaded execution. In this last task, you will modify your implementation so that it supports multiple threads reading/writing the table at the same time.

You will need to have latches on each block so that when one thread is writing to a block other threads are not reading or modifying that index as well. You should also allow multiple readers to be reading the same block at the same time.

You will need to latch the whole hash table when you need to resize. When resize is called, the size that the table was when resize was called is passed in as an argument. This is so that if the table was resized while a thread was waiting for the latch, it can immediately give up the latch and attempt insertion again.

##### REQUIREMENTS AND HINTS

- You are not allowed to use a global scope latch to protect your data structure for each operation. In other words, you may not lock the whole container and only unlock the latch when operations are done.
- We are providing you a `ReaderWriterLatch` (`src/include/common/rwlatch.h`) that you can use in your hash table. There are also helper functions in the `Page` base class to acquire and release latches (`src/include/page/page.h`).
- Sone of your hash table functions will be given a `Transaction` (`src/include/concurrency/transaction.h`) object. This object provides methods to store the page on which you have acquired latch while traversing through the Hash Table.