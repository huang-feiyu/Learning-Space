# CMU-154-45: 


## Before this course:


* Required Reading:  <a href=../Resources/数据库系统概念_原书第6版.pdf>Chapter 11.6-11.7</a>


### 11.6 静态散列
* 基于hashing技术的文件组织能够避免访问索引结构，同时hashing也提供了一种构造索引的方法。
* 使用 Bucket 来表示能够存储一条或者多条记录的一个存储单位，
  通常一个bucket就是一个磁盘块
* Formally, K==Search key, B==address of bucket
  h(hashing function) 是一个从K到B的函数
* hashing的目的
    * hash file organization中，通过计算K上的函数可以直接获得
      包含该记录的磁盘块地址
    * hash index organization中，把K和B组织成一个散列函数结构

#### Hashing function
* 分布是均匀的
* 分布是随机的
**散列函数的设计需要认真仔细，良好的散列函数一般情况下查找所花费的时间是一个小常数**

#### Bucket Overflow
桶溢出的几个原因:
* 桶不足
* skew：偏斜
    * 多条记录可能记由相同的搜索码
    * 所选的哈希函数可能会导致搜索码的分布不均匀

解决方法: 
**(close addressing or closed hashing)**
* 使用over3ow bucket 溢出桶来解决桶溢出的问题
    * 链接列表形式的溢出处理，overflow chaining
    (open addressing)
* 当一个桶满了之后，将记录插入到其他桶中
    * 一种策略是linear probing, 按照轮转顺序还存在多余空间的桶

缺点：
* B太小，一个桶中可能包含许多不同的搜索码值的记录，发生桶溢出
* B太大，可能会浪费很多空间

#### Hash Index
* 散列索码及其相应的指针组织成散列文件结构。
* 构建散列索引：将散列函数作用于搜索码以确定对应桶的位置,
  然后将此搜索码及其对应指针存入此桶中
  **散列索引是一种辅助索引结构，也能够认为散列形式组织的文件上也有一个聚集散列索引** 

### 11.7 动态散列
* 允许散列函数动态发生变化，以适应数据库增大或者缩小的需要
**Extendable Hashing**

#### Data Structure
* 选择一个具有均匀性和随机性特性的散列函数，但是该散列函数产生的值的范围较大，
  是b位二进制整数，一个典型的b值是32.
* 按照需求建桶
* 几个连续的表项可能指向同一个桶, 所有这样的表项拥有一个共同的散列前缀

#### 查询和更新
* 查询,K<sub>l</sub>的桶的位置，取得h(kl)的前i个高位，
  然后为这个位串查找对应的表项，再根据表项中的指针确定桶的位置
* 插入, 定位一个桶按照是否存在多余空间来进行更新
    * 如果存在多余空间直接插入
    * 否则根据索引前缀判断是否增加桶的数目
* 删除, 定位一个桶按照是否存在来进行更新
    * 如果存在空间直接删除
    * 否则根据索引前缀判断是否删除桶的数目

#### 优缺点
* 优点
    * 空间开销很小
    * 性能不随文件的增长而降低
* 缺点
    * 查找的时候涉及一个复角的间接层

### Papers: 

#### [Fibonacci Hashing](./Material/Fibonacci_Hashing.md)
* Fibonacci Hashing: From Knuth's multiplicative method.
* The Fastest Method in tests     
Fibonacci hashing is just a simple multiplicative hash with a well-chosen magic
number.

##### How it works
* Golden ratio: phi=1.6180339...
```c++
size_t fibonacci_hash_3_bits(size_t hash)
{
    return (hash * 2^64/phi) >> 61;
}
```
* It gives a pretty even distribution. 
* Though it doesn't make for a great hash funcion, but we don't need to control
  the hash function anyway. We just want to **use it**.

##### Why fibonacci hashing is so powerful?
* Fast
* Mix up input patterns
Although the fibonacci number may be the only disadvantage here.

##### Why nobody use it?
* In author's opinion, because of historical misunderstanding.
* The prejudice towards multiplicative hashing.

##### Conclusion
Fibonacci hashing may not be the best hash function, but it's the best way to
map from a large range of numbers into a small range of numbers.


#### [All hash table sizes](./Material/All_hash_table_sizes.md)
```c++
class HashTable {
    primes::Prime prime;
    vector table;
public:
    HashTable(uint64_t size); {
        prime = primer::Prime::pick(size);
        table.resize(prime.get());
    }
    ...
    Entry* getEntry(uint64_t hash) {
        return table[primer.mod(hash)];
    }
}
```


## [In the Course](https://www.youtube.com/watch?v=1D81vXw2T_w&list=PLSE8ODhjZXjbohkNBWQs_otTrBTrjyohi&index=6&ab_channel=CMUDatabaseGroup)

#### Introduction
* Disk Manager
* Buffer pool Manager
* **Access Methods**
    * Hash Tables
    * Trees
* Operator Execution
* Query Planning

* Data Structure in DBMS:
    * Internal Meta-data
    * Core Data Storage
    * Temporary Data Structures
    * Table Indexes

#### Design decisions
* Data Organization:
    * How we layout data structure in memory/pages and what information to store
      suppory efficient access
* Concurrency
    * How to enable multiple threads to access the data structure at the same
      time without causing problems

#### Hash tables 
* implements an unordered associative array that maps keys to values
* It uses a hash function to compute an offset into the array for a given key,
  from which the desired value can be found
* Space Complexity: O(n)
* Operation Complexity: O(1) to O(n)

##### Static hash Table
* Allocate a giant array that has one slot for every element you need to store
* To find an entry, mod the key by the number of elements to find the offset in
  the array.
* Each key is unique
* You know the number of elements ahead of time

* Perfect hash function: key1!=key2, then hash(key1)!=hash(key2)

#####  Design decisions
* #1: Hash Function
    * How to map a large key space into a smaller domain
    * Trade-off between being fast vs. collision rate
* #2: Hashing Scheme
    * How to handle key collisions after hashing
    * Trade-of between allocating a large hash table vs.
      additional instructions to find/insert keys

### Hash Functions
* For any input key, return an integer representation of that key
* We do not want to use a cryptographic hash function for DBMS hash tables
* We want something that is fast and has a low collision rate

#### Lists of hash funcions
* CRC-64: Used in networking for error detection
* MurmurHash: Designed to a fast, general purpose hash funcion
* Google CityHash: Designed to be faster for short keys
* **Facebook XXHash**: From the creator of zstd compression
* Google FarmHash: Newer version of cityHash with better collision rate

### Static Hashing Schemes

We need to be told how many memory we need.

#### Approach #1: Linear Probe Hashing
* Single giant table of slots
* Resolve collisions by linearly searching for the next free slot in the table
    * To determine whether an element is present, hash to a location in the
      index and scan for it
    * Have to store the key in the index to know when to stop scanning
    * Insertions and deletions are generalizations of lookups
    * Delete: Tombstone, set it to tombstone; Movement, move everyone following, but the first one is "nervous"

##### Non-unique keys
* Choice#1: Separate Linked List, store values in separate storage area for each
  key
* Choice#2: Redundant keys, store duplicate keys entries together in the hash
  table (复制)

#### Approach #2: Robin Hood Hashing
* Variant of linear probe hashing that steals slots from "rich" keys and give
  them to "poor" keys
    * Each key tracks the number of positions they are from where its optimal
      position in the table
    * On insert, a key takes the slot of another key if the first key is farther
      away from its optimal position than the second key

#### Approach #3: Cuckoo Hashing
* Use multiple hash tables with different hash function seeds
    * On insert, check every table and pick anyone that has a free slot
    * if no table has a free slot, evict the element from one of them and then
      re-hash it find a new location
* Look-ups and deletions are always O(1) because only one location per hash
  table is checked

#### OBSERVATION
* The previous hash tables require the DBMS to know the number of elements it
  wants to store
    * Otherwise it has rebuild the table if it needs to grow/shrink in size

### Dynamic Hashing Schemes

#### Chained Hashing
* Maintain a linked of buckets for each slot in the hash table
* Resolve collisions by placing all elements with the same hash key into the
  same bucket
    * To determine whether an element is present, hash to its bucket and scan
      for it
    * Insertions and deletions are generalizations of lookups

#### Extendible Hashing
* Chained-hashing approach where we split buckets instead of letting the linked
  list grow forever
* Multiple slot locations can point to the same bucket chain
* Reshuffling bucket entries on split and increase the number of bits to examine
    * Data movement is localized to just the split chain

#### Linear Hashing
* The hash table maintains a pointer that tracks the next bucket to split
    * When any bucket overflows, split the bucket at the pointer location
* use multiple hashes to find the right bucket for a given key
* Can use different overflow criterion:
    * Space Utilization
    * Average Length of Overflow Chains

### Conclusion
* Fast data structure that support O(1) lookups that are used all throughout the
  DBMS internals
* Hash Tables are usually not what you want to use for a table index

## Exercise

[Index](../exercise/homework2/hw2-clean.pdf)

