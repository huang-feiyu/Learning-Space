### Week 4

[TOC]

##### Priority Queue

###### API and elementary implementation

> 总是处理最优先的结点。

```java
public class MaxPQ<Key extends Comparable<Key>>
```

* Application
  * Huffman codes
  * Dijkstra's algorithm, Prim's algorithm
  * sum of powers
  * A* search
  * etc.
* Challenge: Find the largest $M$ items in a stream of $N$ items
  * use a MinPQ, remove $N - M$ items

两种基本实现：unordered array; ordered array.

* Time complexity
  * `insert`: $O(\lg N)$
  * `delMax`: $O(\lg N)$
  * `max`: $O(\lg N)$

###### Binary Heaps

> Peter principle: Node promoted to level of incompetence.

完全二叉树：perfectly balanced, except for bottom level.

* `a[1]`是根节点，最大的结点 (do not use `a[0]`)
* Parent 必然大于 Children
  * parent: $\lfloor k/2\rfloor$
  * the $k$th node
  * child: $2k \or 2k+1$

[pdf](./Slides/PriorityQueues.pdf)

* Time complexity
  * `insert`: $O(\log N)$
  * `delMax`: $O(\log N)$
  * `max`: $O(1)$

* Challenge
  * Immutability of keys
    * `final`
    * `String` type, etc.
  * Underflow and overflow
  * Minimum-oriented priority queue (implement like MaxPQ)

###### Heap sort

> In place sort, not stable, unfriendly to cache.

1. 构造堆：将原始数组重新组织安排进堆中
   * 从右向左使用`sink()` $O(N)$
2. 下沉排序：从堆中按照递减顺序取出所有元素并得到排序结果
   * MaxPQ

[8 Puzzle](./Solutions/8 Puzzle) (use A* Algorithm)

##### Symbol tables

###### API

> 实现 Key-Value 的 `insert` & `search`
>
> Redis： 梦开始的地方，哈哈哈。

* `public class ST<Key, Value>`

* Best practice: Use Immutable types for ST
* Equality test: `equals()`
  * 满足等价关系
    1. `x == y`
    2. first, check if `y == this`; then, use our own type (check all significant fields are the same)

###### Implementations

* Linked List: Maintain an unordered linked list of k-v pairs
  * search: scan all until match  (N/2)
  * insert: scan all to change or add (N)
* Binary search in an ordered array: Maintain to array `keys[]`, `values`
  * get: rank it and get it (log N)
  * rank: binary search
  * insert: to insert, need to shift all greater keys over (N/2)

###### Ordered ST operations

```java
public class ST<Key extends Comparable<Key>, Value>
```

* `min`
* `max`
* `floor`
* `ceiling`
* `select`
* `rank`

##### Binary Search Trees

> An efficient implementation of symbol table.

* BST: binary tree in symmetric order
  * two disjoint binary trees (left and right)
  * symmetric order: Every node's key is larger than all keys in its left subtree; smaller than all keys in its right subtree

###### Ordered ST operations

Use BST to implement the method.

* Inorder traversal: `Queue`

###### Deletion

1. Lazy approach: set its value to null
   * tombstone
2. Hibbard deletion(Tree becomes unbalanced $\Rightarrow O(\sqrt{N})$ ): search for node $t$ containing key $k$
   * Case 0 (no children): delete $t$ by setting parent link to null
   * Case 1 (1 child): Delete $t$ by replacing parent link
   * Case 2 (2 child):
     * Find successor $x$ of $t$ (x has no left child)
     * Delete the minimum in $t$'s right subtree (but don't garbage collect x)
     * Put $x$ in $t$'s spot (still a BST)



Deleting the minimum: 

* Go left until finding a node with a null left link
* Replace that node by its right link
* Update subtree counts

