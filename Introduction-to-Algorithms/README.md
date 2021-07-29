# Introduction-to-Algorithms
[MIT Open Course](https://ocw.mit.edu/): [MIT-6.046J](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-046j-introduction-to-algorithms-sma-5503-fall-2005/index.htm)

这个课程是Fall 2005时的课程，现在已经出现了更新版本的课程。但是，我还是选用2005版本——因为各个方面的中文互联网资源更加成熟。

* [课程资源打包](./MIT-6046J/Resources/6-046j-fall-2005.zip)
* 教材
  * [算法导论第三版](./MIT-6046J/Resources/算法导论（原书第3版）.pdf)
  * [Introduction to Algorithms 3rd](./MIT-6046J/Resources/Introduction-to-Algorithms-3rd.pdf)
  * [Answer](./MIT-6046J/Resources/Answer.pdf)
* 视频
  * [Bilibili](https://www.bilibili.com/video/BV1Kx411f7bL)
  * [YouTube](https://www.youtube.com/playlist?list=PL8B24C31197EC371C)

### 前言

该仓库会记录我的笔记、算法实现和一些课程的资源。

课程要求前置：对于编程的理解——也就是大一学习完毕，概率论学习。

> A strong understanding of programming and a solid background in discrete mathematics, including probability, are necessary prerequisites to this course.
>
> For MIT Students, this course is the header course for the MIT/EECS Engineering Concentration of Theory of Computation. You are expected to have taken [6.001](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-001-structure-and-interpretation-of-computer-programs-spring-2005/index.htm) Structure and Interpretation of Computer Programs and [6.042J / 18.062J](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-042j-mathematics-for-computer-science-spring-2015) Mathematics for Computer Science, and received a grade of C or higher in both classes. If you do not meet these requirements, you must talk to a TA before registering for the course.

### 项目目录

MIT-6046J
<<<<<<< HEAD
├── Course # :  `#` a.k.a. number

│      ├── Course#\_note.md: 笔记

│      └──  Implements: 代码的实现

├── Resources: 课程的一些资源

├── Exercise: 课程assignment 和 Exam的一些笔记和体会

└── image

### 课程代码实现

代码实现会通过C++实现，利用cMake或者Visual Studio构建项目。该条目包括代码是否成功的图片。

### 课程日历

|       |                                                              |                                             |
| :---- | :----------------------------------------------------------- | :------------------------------------------ |
| SES # | TOPICS                                                       | KEY DATES                                   |
| L1    | Administrivia  Introduction  Analysis of Algorithms, Insertion Sort, Mergesort | Problem set 1 out                           |
| R1    | Correctness of Algorithms  Horner's rule                     |                                             |
| L2    | Asymptotic Notation  Recurrences  Substitution, Master Method |                                             |
| L3    | Divide-and-Conquer: Strassen, Fibonacci, Polynomial Multiplication |                                             |
| R2    | Recurrences, Sloppiness                                      |                                             |
| L4    | Quicksort, Randomized Algorithms                             | Problem set 1 due  Problem set 2 out        |
| R3    | Heapsort, Dynamic Sets, Priority Queues                      |                                             |
| L5    | Linear-time Sorting: Lower Bounds, Counting Sort, Radix Sort |                                             |
| L6    | Order Statistics, Median                                     |                                             |
| R4    | Applications of Median  Bucketsort                           |                                             |
| L7    | Hashing, Hash Functions                                      | Problem set 2 due  Problem set 3 out        |
| L8    | Universal Hashing, Perfect Hashing                           | Homework lab tonight                        |
| R5    | Quiz 1 Review                                                | Problem set 3 due                           |
| Q1    | Quiz 1, In-class                                             |                                             |
| R6    | Binary Search Trees, Tree Walks                              |                                             |
| L9    | Relation of BSTs to Quicksort  Analysis of Random BST        | Problem set 4 out                           |
| L10   | Red-black Trees, Rotations, Insertions, Deletions            |                                             |
| R7    | 2-3 Trees, B-trees                                           |                                             |
| L11   | Augmenting Data Structures, Dynamic Order Statistics, Interval Trees | Problem set 4 due  Problem set 5 out        |
| L12   | Skip Lists                                                   |                                             |
| R8    | Range Trees                                                  |                                             |
| L13   | Amortized Algorithms, Table Doubling, Potential Method       | Problem set 5 due  Problem set 6 out        |
| L14   | Competitive Analysis: Self-organizing Lists                  |                                             |
| R9    | Competitive Analysis: Ski Rental, Randomized Competitive Algorithm |                                             |
| L15   | Dynamic Programming, Longest Common Subsequence              | Problem set 6 due  Problem set 7 out        |
| L16   | Greedy Algorithms, Minimum Spanning Trees                    |                                             |
| L17   | Shortest Paths I: Properties, Dijkstra's Algorithm, Breadth-first Search | Problem set 7 due  Problem set 8 out        |
| L18   | Shortest Paths II: Bellman-Ford, Linear Programming, Difference Constraints |                                             |
| R10   | Graph Searching: Depth-first Search, Topological Sort, DAG Shortest Paths |                                             |
| L19   | Shortest Paths III: All-pairs Shortest Paths, Matrix Multiplication, Floyd-Warshall, Johnson | Problem set 8 due                           |
| L20   | Quiz 2 Review                                                |                                             |
| L21   | Ethics, Problem Solving (Mandatory Attendance)               | Take-home quiz 2 handed out                 |
| Q2    | Quiz 2, In-class                                             | Take-home quiz 2 due two days after Ses #Q2 |
| L22   | Advanced Topics                                              | Problem set 9 out                           |
| L23   | Advanced Topics (cont.)                                      | Homework lab tonight                        |
| R11   | Advanced Topics                                              | Problem set 9 due                           |
| L24   | Advanced Topics (cont.)                                      |                                             |
| L25   | Advanced Topics (cont.)  Discussion of Follow-on Classes     |                                             |
|       | Final Exam                                                   |                                             |

### 要求阅读

| SES # | TOPICS                                                       | READINGS                                                     |
| :---- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| L1    | Administrivia  Introduction  Analysis of Algorithms, Insertion Sort, Mergesort | Chapters 1-2                                                 |
| R1    | Correctness of Algorithms  Horner's rule                     |                                                              |
| L2    | Asymptotic Notation  Recurrences  Substitution, Master Method | Chapters 3-4, excluding section 4.6                          |
| L3    | Divide-and-Conquer: Strassen, Fibonacci, Polynomial Multiplication | Sections 4.2 and 30.1                                        |
| R2    | Recurrences, Sloppiness                                      |                                                              |
| L4    | Quicksort, Randomized Algorithms                             | Sections 5.1-5.3  Chapter 7                                  |
| R3    | Heapsort, Dynamic Sets, Priority Queues                      | Chapter 6                                                    |
| L5    | Linear-time Sorting: Lower Bounds, Counting Sort, Radix Sort | Sections 8.1-8.3                                             |
| L6    | Order Statistics, Median                                     | Chapter 9                                                    |
| R4    | Applications of Median  Bucketsort                           | Section 8.4                                                  |
| L7    | Hashing, Hash Functions                                      | Sections 11.1-11.3                                           |
| L8    | Universal Hashing, Perfect Hashing                           | Section 11.5                                                 |
| R5    | Quiz 1 Review                                                |                                                              |
| Q1    | Quiz 1, In-class                                             |                                                              |
| R6    | Binary Search Trees, Tree Walks                              | Sections 12.1-12.3                                           |
| L9    | Relation of BSTs to Quicksort  Analysis of Random BST        | Section 12.4                                                 |
| L10   | Red-black Trees, Rotations, Insertions, Deletions            | Chapter 13                                                   |
| R7    | 2-3 Trees, B-trees                                           |                                                              |
| L11   | Augmenting Data Structures, Dynamic Order Statistics, Interval Trees | Chapter 14                                                   |
| L12   | Skip Lists                                                   | Skip Lists handout ([PDF](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-046j-introduction-to-algorithms-sma-5503-fall-2005/readings/l12_skiplists.pdf)) |
| R8    | Range Trees                                                  |                                                              |
| L13   | Amortized Algorithms, Table Doubling, Potential Method       | Chapter 17                                                   |
| L14   | Competitive Analysis: Self-organizing Lists                  | Sleator, Daniel D., and Robert E. Tarjan. "Amortized efficiency of list update and paging rules." *Communications of the ACM* 28, no. 2 (February 1985): 202-208. |
| R9    | Competitive Analysis: Ski Rental, Randomized Competitive Algorithm |                                                              |
| L15   | Dynamic Programming, Longest Common Subsequence              | Chapter 15                                                   |
| L16   | Greedy Algorithms, Minimum Spanning Trees                    | Sections 16.1-16.3 and 22.1  Chapter 23                      |
| L17   | Shortest Paths I: Properties, Dijkstra's Algorithm, Breadth-first Search | Section 22.2  Chapter 24                                     |
| L18   | Shortest Paths II: Bellman-Ford, Linear Programming, Difference Constraints |                                                              |
| R10   | Graph Searching: Depth-first Search, Topological Sort, DAG Shortest Paths | Sections 22.3-22.4                                           |
| L19   | Shortest Paths III: All-pairs Shortest Paths, Matrix Multiplication, Floyd-Warshall, Johnson | Chapter 25                                                   |
| L20   | Quiz 2 Review                                                |                                                              |
| L21   | Ethics, Problem Solving (Mandatory Attendance)               |                                                              |
| Q2    | Quiz 2, In-class                                             |                                                              |
| L22   | Advanced Topics                                              | Dynamic Multithreaded Algorithms handout ([PDF](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-046j-introduction-to-algorithms-sma-5503-fall-2005/readings/dyn_multi_alg.pdf)) |
| L23   | Advanced Topics (cont.)                                      |                                                              |
| R11   | Advanced Topics                                              |                                                              |
| L24   | Advanced Topics (cont.)                                      | Demaine, Erik D. "Cache-Oblivious Algorithms and Data Structures." To appear in *Lecture Notes from the EEF Summer School on Massive Data Sets*, a volume of *Lecture Notes in Computer Science*. Berlin, Germany: Springer-Verlag. |
| L25   | Advanced Topics (cont.)  Discussion of Follow-on Classes     |                                                              |
