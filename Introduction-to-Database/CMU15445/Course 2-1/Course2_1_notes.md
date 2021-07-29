# CMU-154-45: 

## Before this course:

* Required Reading:  <a href=../Resources/数据库系统概念_原书第6版.pdf>Chapters 7-8</a>

### Chapter 7

##### 设计过程概览
* 设计阶段：
    * 用户需求
    * 概念设计
    * 逻辑设计阶段
    * 物理设计阶段
* 设计选择:
    * avoid冗余
    * avoid不完整

##### E-R (entity-relationship)
* 实体集(entity set)
    * 相同类型的具有相同性质的一个实体集合
    * 实体通过一组属性来表示, 每个属性都有一个值
* 关系集(relationship)
    * 相同类型关系的集合
    * 参与关系集的实体集数目称为度degree 
* 属性(attribute)
    * 每一个属性都有一个可以取值的集合,称为domain
    * 有简单属性也有复杂属性

##### 约束
* 映射基数(mapping cardinality)
    * 表示一个实体通过关系集能够关联的实体的个数
    * 研究二元关系集
    * one-to-one, one-to-many, many-to-one, many-to-many
* key
    * primary key
    * super key
    * candidate key

##### 后面的都不太重要
* 数据约束，关系数据库设计
* 查询与性能
* 授权需求
* 数据流，工作流
* 持久性，连续性

### Chapter 8

##### 好的关系设计的特点
* 设计选择：更大的模式
    * 冗余
    * 存在空值
    * 数据原子性不能保证
* 设计选择：更小的模式
    * 函数依赖
    * 模式分解

##### 原子域与第一范式
* atomic: 该域的元素不可再分
* 1NF(First Normal Form): 所有属性的域都是原子的

##### 使用函数依赖进行分解
* 码和函数依赖
    * R的子集K是r(R)超码的条件：在r(R)的合法实例中没有两条元组在属性集K上可能具有相同的值
    * 满足函数依赖的a->b条件：对于所有元组对都满足函数关系
    * 函数依赖能够使我们表示不能用超码表示的约束
    * 闭包
* Boyce-Codd Normal Form: BCNF
    * 消除所有的冗余
    * 具有函数依赖集F的关系模式R属于BCNF的条件：
    对于闭包中的所有a->b的函数依赖，至少a->b是平凡的函数依赖或者a是R的超码
* BCNF和保持依赖
* 3NF: third normal form
    * 条件：对于闭包关系中所有a->b的函数依赖，至少a->b是一个平凡的函数依赖或者a是R的超码或者b-a中的每一个属性A都包含于R的一个候选码中
    * 允许BCNF中不允许的函数依赖

##### 函数依赖理论
* 函数依赖集的闭包: 
    * 满足 reflexivity rule, augmentation rule, transitivity rule, union rule,
      decomposition, pseudotransitivity rule
* 属性集的闭包: 算法实现
* 正则覆盖:
    * 覆盖, 离散数学
* 无损分解: 算法
* 保持依赖: 算法

##### 分解算法
* BCNF分解
* 3NF分解

### Papers:




## [In the Course:](https://www.youtube.com/watch?v=guOyZBnSKXg&list=PLSE8ODhjZXjYutVzTeAds8xUt1rcmyT7x&index=4&ab_channel=CMUDatabaseGroup)

### Database Design
* How do we design a "good" database schema?
* We want to ensure the integrity of the data.
* We also want to get good performance.

* Redundancy problems: Decomposition to solve the problem
    * Update Anomalies
    * Delete Anomalies
    * Insert Anomailes

### Functional Dependencies
* FD: A form of a constraint(约束)
* Part of a relation's schema to define a valid(有效的) instance
* Definition: X->Y
    * The value of X functionally defines the value of Y
* Formal Definition: If two tuples(t1, t2) agree on the X attribute, then they
  must agree on the Y attribute, too.
* FD is a constraint that allows instances for which the FD holds
* You can check if an FD is violated by an instance, but you cannot prove that
  an FD is part of the schema using an instance

##### SQL Assertion to check FD 
* If you check if there is a FD, you may need to run query of a entire table
* As of 2017, no major DBMS supports SQL-92 assertions

##### Why do we care FDs?
* They allow us to decide whether a database design is correct.
* Note that this different then the question of whether it's a good idea for
  performance

##### Implied dependencies(隐含依赖)
* Compute the closure
* With the closure we can find all FD's easily and then compute the attribute
  closure
* We want to a minimal set of FDs that was enough to ensure correctness

### Canonical Cover: 正则覆盖
* Given a set F of FDs {f1,...,fn}, we define the canonical cover Fc as the
  minimal set of all FDs
* A canonical cover Fc must have the following properties:
    * The RHS(Right-hand side) of every FD is a single attribute
    * The closure of Fc is identical to the closure of F
    * The Fc is minmal
* The canonical cover is the minimum number of assertions that we need to
  implement to make sure that our data base integrity is correct

##### Relatonal Model keys
**Candidate key is super key, not all super key is candidate key**
* Super Key: 
    * Any set of attributes in a relation that functionally determines
      all attributes in the relation
    * Set of attributes for which there are no two distinct tuples with the same
      values for the attributes in this set
    * A set of attributes that uniquely identifies a tuple
* Candidate Key:
    * Any super key such that the removal of any attribute leaves a
      set that does not cunctionaaly determine all attributes
    * Set of attributes that uniquely identifies a tuple according to a key
      constraint
    * A minimal set of attributes that uniquely identifies a tuples
* Primary Key:
    * Usually just the candidate key

* Super keys:
    * They help us determine whether it is okay to decompose a table into
      multiple sub-tables
    * Super keys ensure that we are able to recreate the original relation
      through joins

### Schema Decomposition
* split a single relation R into a set of relations {R1,...,Rn}
* Not all decompositions make the database schema better
    * Update Anomalies
    * Insert Anomalies
    * Delete Anomalies
    * Wasted Space
* Goal:
    * **Lossless Joins**(无损的): Want to be able to reconstruct original relation by
      joining smaller ones using a natural join
    * Dependency Preservation: Want to minimize the cost of global integrity
      constraints based on FD's. A schema preserves dependencies if its original
      FDs do not span multiple tables
    * Redundancy Avoidance: Avoid unnecessary data duplication
##### Decomposition summary
* Lossless Joins:
    * Motivation: Avoid information loss 
    * Goal: No noise introduced when reconstituting universal relation via joins
    * Test: At each decomposition `R=(R<sub>1</sub> ∪ R<sub>2</sub>)`, check
      whether `(R<sub>1</sub> ∩ R<sub>2</sub>) -> R<sub>1</sub>` or `(R<sub>1</sub> ∩ R<sub>2</sub>) -> R<sub>2</sub>`
* Dependency Preservation:
    * Motivation: Efficient FD assertions
    * Goal: No global integrity constraints that require joins of more than one
      table with itself
    * Test: `R = (R1 U...U Rn)` is dependency preserving if closure of FD's
      covered by each R1 = closure of FD's covered by R=F
* Redundancy Avoidance:
    * Motivation: Avoid update, delete anomalies
    * Goal: Avoid update anomalies wasted space
    * Test: For an X->Y covered by Rn, X should be a super key of Rn

### Conclusion
* Functional dependencies are simple to understand
* They will allow us to reason about schema decompositions

## Exercise

