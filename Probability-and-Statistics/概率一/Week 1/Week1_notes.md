### [第一周](https://www.coursera.org/learn/prob1/home/week/1)

[LaTeX数学符号表示](http://mohu.org/info/symbols/symbols.htm)

##### 课程简单介绍

* 第一门华语概率mooc
* 概率与生活十分接近的学问
* 课程中偏理论的东西减少一些，使用直观去理解概率

##### 概率概论

* Wheel of Fortune: 幸运之轮
  * 概率：占据轮盘的部分
* 为什么学概率
  * 我们对于这个世界了解的太少了，许多东西不能够确切地描述——人的局限性，也就是非理性
    * 我们无法认知，那么我们只能够用概率去解释世界——的确，我相信有些东西永远无法认知
  * 而有些事情并非必然的，本身就是随机的——根据我理解的量子力学，一切都是随机的
* 概率与统计的差异
  * 概率：**概率模型已知**，要学会如何去算某些事情的概率
  * 统计：**概率模型未知**，要学会如何从大量的实验数据中去建立机率模型
  * 一般先学机率，在学统计。但实际生活中，先使用统计建立模型，然后利用机率去解决问题

##### 集合论

* 概率函数
  * 自变量：**事件**，本质是**集合**

###### 名词复习

* 元素 Element
* 集合 Set
  * 元素组成的团体
* 子集 Subset
* 全集(宇集) Universal Set
* 空集 Empty Set ==> $\phi$
* 交集 Intersection ==> $\cap$
* 并集(联集) Union ==>  $\cup$
* 补集  Complement ==> C = A<sup>C</sup>
* 差集 Difference ==>  -
* 不相交 Disjoint ==> X $\cap$​​ Y = $\phi$​
* 互斥 Mutually Exclusive ==> 一群集合中任选两个集合都不想交，这群集合互斥

###### De Morgan's Law

证明两个集合相等：你中有我，我中有你

$(A \cup B)^C = A^C \cap B^C$

 ![image-20210806161848883](Week1_notes.assets/image-20210806161848883-16282379300641.png)

$Prove:$ 

$\to:$​

$Assume\ x \in (A \cup B)^C$​​

$\Rightarrow x \notin A \cup B$​

$\Rightarrow x \notin A\ and\ x \notin B$

$\Rightarrow x \in A^C\ and\ x \in B^C \Rightarrow$ $A^C \cap B^C$

##### 概率名词

* 实验 Experiment
  * 因为事情的结果不清楚，所以需要做实验
  * 包含元素
    * 步骤 procedures
    * 模型 model
    * 观察 observations
* 结果 Outcome
* 样本空间 Sample Space
  * 概率实验所有可能的结果的集合，通常使用$S$（宇集）表示
* 事件 Event
  * 事件​是**对实验结果的某种描述**
  * 概率描述结果符合某事件的叙述的机会多大
  * 数学上，*事件* 可以看成是 *结果* 的集合，也就是 *样本空间*  的子集
* 事件空间 Event Space
  * *事件空间*  = set of sets
  * **包含所有事件的空间**
  * 如果样本空间$S$有$n$​个结果，事件空间的有$2^n$个元素
* 概率是一个函数，自变量是事件
  * 概率能够看作是一个映射
  * 概率函数：从事件空间映射到$[0,1)$

##### 补充

* 样本空间，也称为基本事件空间===>单一结果组成的集合
  * $\omega$表示基本事件，$\Omega$表示基本事件空间
* 事件空间似乎并没有用
