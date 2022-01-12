### Week 1

[TOC]

##### Course Introduction

> 算法是诗意的，却不是神秘的。

* Course Overview
  * Data types
  * Sorting
  * Searching
  * Graphs
  * Strings
  * Advanced

[book site](https://algs4.cs.princeton.edu/home/)

[Hello World](./Solutions/HelloWorld/)

##### Union-Find

> 解决动态连通性的算法

###### Dynamic Connectivity

* 问题描述：给定 N 个对象与连接关系，判断两个对象之间是否连通
  * 动态：合并和连通操作混合
  * Return Boolean value
* 问题建模：该问题可以用于非常多的现实问题——连通图
  * $0 \sim N-1$ 作为 $N$ 个对象
  * 【连接】应该是一个等价关系
  * 【连通分量】
* Data type: `class UF`
  * `union(p, q)`: 似乎有方向，又好像没有
  * `connected`
  * `find`
  * `count`: 连通分量的数目

###### Quick-find

> An eager approach: executes immediately and returns a result
>
> 本算法的 `find` 操作很快，$O(1)$，但是 `union` 太慢了。

* Data type: `Array[N]`
* Find: detemine whether it is equal
  * $O(1)$
* Union: Merge
  * $O(N)$

###### Quick-union

> A lazy approach: defers computation until it is necessary to execute and then produces a result
>
> 与Quick-find互补的算法

* Data type: `Array[N]`

  * 类似于一棵树，如果树根相同，那么属于同一个连通分量
  * Root: `Array[Root]==Root`, 向前回溯获得根节点
* Find: Check whether two have the same root

  * $O(\text{height of tree})$
* Union: Set $p$'s root to $q$'s root

  * $O(\text{height of tree})$


###### Quick-union Improved

* 加权(Weighting)
  * 避免产生大树(高度)，让小树成为大树的儿子

* Data type
  * `Array[N]`
  * `sz[N]`: 权值，该结点的孩子数
* Find: Check whether two have the same root
  * $O(\lg N)$
* Union: 权值小的成为权值大的子树
  * $O(\lg N)$

---

* 路径压缩(path compression)
  * 在寻找的时候，将包含给定结点的子树直接指向根节点——将路径展平

```java
// Only one line
id[i] = id[id[i]];
```

$N$ objects, $M$ operations $\Rightarrow$ $c(N+M\cdot\lg^* N)$

> There is not linear time algorithm to solve union-find problem.

###### Application

* Percolation
  * 是否存在从一个地方到另一个地方的通路
  * 判断是否导电、判断水是否渗透、社交网络

[Percolation](./Solutions/Percolation)

##### Analysis of Algorithms

使用科学的方法去分析算法：假说检验方法。

* observations
* mathematical models
  * $O, \Omega, \Theta, \omega, \theta$
  * $\sim$
* order-of-growth classification
  * $1, \log N, N, N\log N, N^2, N^3, 2^N$
* theory of algorithms
  * Best case: Lower bound on cost $\Omega$
  * Worst case: Upper bound on cost  $O$
  * Average case: Expected cost for random input  $\Theta$
* memory
  * Bit: 0/1
  * Byte: 8bits
  * KB: $2^{10}$
  * MB: $2^{20}$
  * GB: $2^{30}$
  * Objects in Java
    * Object overhead: 16bytes
    * Reference: 8 bytes 
    * Padding: Each object uses a multiple of 8 bytes
