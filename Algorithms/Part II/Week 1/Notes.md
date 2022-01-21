# Week 1

[TOC]

## Undirected Graphs

* Definition: Set of **vertices** connected pairwise by **edges**
* Path: Sequence of vertices connected by edges
* Cycle: Path whose first and last vertices are the same

### Graph API

* Graph representation
  * Graph drawing: Provides intuition about the structure of the graph
    * Intuition can be misleading
  * Vertex: use integers $0 \sim V-1$

```java
public class Graph
```

* Adjacency-list graph: Maintain vertex-indexed array of lists
* Adjacency-matrix: 邻接矩阵
* List of edges

### DFS

> Maze exploration

系统地遍历一个图。

* Design Pattern: Decouple graph data type from graph processing

* DFS:
  * To visit a vertex $v$: (traverse all vertex reachable to $v$)
    * Mark vertex $v$ as visited
    * Recursively visit all unmarked vertices adjacent to $v$ 

### BFS

* Repeat until queue is empty:
  * Remove $v$ from queue
  * Add to queue all unmarked vertices adjacent to $v$ and mark them

### Connected Components

* Connectivity: Vertices $v$ and $w$ are connected if there is a path between them
* Connected Components: 连通分量

---

> Partition vertices into connected components.

* Initialize all vertices $v$ as unmarked
* For each unmarked vertex $v$, run DFS to identify all vertices discovered as part of the same component
  * use an array `cc[]`

### Challenges

* Is a graph bipartite?
* Find a cycle.
* Find a cycle that uses every edge exactly once.
* Find a cycle that visits every vertex exactly once (Hamiltonian cycle)
* Are two graphs identical except for vertex names? (同构图，除了暴力搜索，没有答案)
* Lay out a graph in the plane without crossing edges?

## Directed Graphs

* Definition: Set of vertices connected pairwise by directed edges.

### API

* Design Pattern: Decouple data type and graph processing

* Implementation:
  * Adjacency-lists digraph 
  * Adjacency-matrix digraph
  * List of edges

### Digraph Search

* DFS
  * Mark $v$ as visited
  * Recursively visit all unmarked vertices pointing from $v$
  * Mark-sweep algorithm: garbage collector 使用有向图判断是否收集垃圾
* BFS
  * Put $s$ onto a FIFO queue, and mark $s$ as visited
  * Repeat until the queue is empty
    * Remove the least recently added vertex $v$
    * Add to queue all unmarked vertices pointing from $v$ and mark them
  * Web crawler

### Topological Sort

> 有环图无拓扑排序

DAG: 有向无环图

* Run DFS
* Return vertices in reverse post-order

### Strong component

* Def: Vertices $v$ and $w$ are strongly connected if there is a *directed* path from $v$ to $w$ and a *directed* path from $w$ to $v$

* Kosaraju-Sharir algorithm: intuition
  * Reverse graph: 余图
  * Kernel DAG: Contract each strong component into a single vertex
  * Algorithm
    * compute topological order in kernel DAG
    * Run DFS, considering vertices in reverse topological order

核心在于**封死连通分量向外走的路**。