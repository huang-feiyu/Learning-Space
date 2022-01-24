# Week 2

[TOC]

## MST

Given un-digraph $G$ with positive edge weights(connected), a <font color=red>spanning tree</font>(生成树) of $G$ is a subgraph $T$ that is both a <font color=red>tree</font> (connected and acyclic) and <font color=red>spanning</font> (includes all of the vertices.

我们需要找到最小生成树(Minimum spanning tree).

* 切分定理：在一个加权图中，给定任意的切分，它的横向边中的权重最小者必然属于图的最小生成树

### Greedy Algorithm

贪心算法：

* 将含有$V$个顶点的任意加权连通图中的最小边标记为黑色
1. 初始状态下每条边都为灰色

2. 找到一种切分使产生的横向边都不是黑色，标记最短边为黑色
3. 反复，直至标记$V-1$条黑边

### API

加权图

```java
public class Edge implements Comparable<Edge>
```

```java
public class EdgeWeightedGraph
```

* adjacency-lists: Maintain vertex-indexed array of Edge lists

```java
public class MST
```

### Kruskal's Algorithm

> A special case of greedy algorithm.

不断选择最短的不产生圈的边，直到边数为$V-1$。

Use the union-find data structure

* Maintain a set for each connected component in $T$
* If $v$ and $w$ are in same set, then adding $v-w$ would create a cycle
* To add $v-w$ to $T$, merge sets containing $v$ and $w$

### Prim's Algorithm

不断选择已选点集合与未选点集合之间最短的边，直到选择到所有的点。

* Lazy implementation
* Eager implementation

## Shorted Path

### API

加权有向图

```java
public class DirectedEdge
```

```java
public class EdgeWeightedDigraph
```

```java
public class SP
```

### SP properties

We can represent the shortest-paths tree(SPT) with two vertex-indexed array.

* 松弛操作

![](https://images2015.cnblogs.com/blog/937718/201608/937718-20160820100015734-431165841.png)

![](https://images2015.cnblogs.com/blog/937718/201608/937718-20160820100021312-298132088.png)

### Dijkstra's Algorithm

单源最短路径（无负边）

* Consider vertices in increasing order of distance from $s$

  (non-tree vertex with the lowest `distTo[]` value)

* Add vertex to tree and relax all edges pointing from that vertex

### Edge-weighted DAGs

* Consider vertices in topological order
* Relax all edges pointing from that vertex

#### Content-aware resizing

* To find vertical seam
  * Grid DAG: vertex = pixel; edge = from pixel to 3 downward neighbors
  * Weight of pixel = energy function of 8 neighboring pixels
  * Seam = shortest path (sum of vertex weights) from top to bottom
* To remove vertical seam:
  * Delete pixels on seam (one in each row)

#### Longest path

* Negate all weights
* Find shortest paths
* Negate weights in result

### Negative weights

加上constant，再处理 $\Rightarrow$ Doesn't work

* 负圈：一个权值总和小于零的圈

```java
// Bellman-Ford algorithm: 处理无负圈的加权有向图
for (int i : G.v())
    for (int j : G.v())
        for (DirectedEdge e : G.adj(v))
            relax(e);
```

[Seam Carving](./Solutions/Seam Carving)
