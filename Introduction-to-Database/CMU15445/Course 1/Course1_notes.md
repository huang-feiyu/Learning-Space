# CMU-154-45: Introduction and Relational Model

## Before this course:

* Required Reading:  <a href=../Resources/数据库系统概念_原书第6版.pdf>Chapters 1-2, 6</a>

### Chapter 01:

1. Goal: 
   * data redundancy and inconsistency
   * difficulty in accessing data
   * data isolation
   * integrity problem(完整性问题)
   * atomicity problem (要么全部发生要么不发生)
   * concurrent-access anomaly (并发访问异常)
   * security problem
2. Concepts:
   * 数据抽象
     * physical level
     * logical level (physical data independence)
     * view level
   * 实例和模式: instance and schema
     * instance: 特定时刻存储在数据库中的信息的集合称作一个实例
     * physical schema, **logical schema**, subschema
3. Data model: 
   * relational model: 表的集合表示数据和数据间的关系
   * entity-relationship model: E-R 基于现实世界的认知
   * object-based data model: E-R增加了封装的结果，与面向对象有异曲同工之妙
   * semi-structured data model: 半结构化数据模型
   * ... network data model & hierarchical data model
4. DDL: data-definition language DML: data-manipulation language
   * DML: 访问和操纵那些按照特定数据模型组织起来的数据
     * 过程化DML & 声明式DML
   * DDL: 定义了数据库模式的实现细节
     * domain constraint(域约束)
     * referential integrity（参照完整性）
     * assertion
     * authorization
5. Relational Database:
   * Table: 每一个表有多个列，每一个列有唯一的名字
   * DML: SQL 返回一个表（非过程化）
   * DDL: SQL 
   * API access: DML有application来执行
6. <a href=https://support.microsoft.com/en-us/office/database-design-basics-eb2159cf-1e30-401a-8084-bd4f9c9ca1f5>Database Design:</a>
   * 需求文档
   * 概念设计，选择数据模型
   * 细节分析
   * 功能需求分析
   * 逻辑设计阶段和物理设计阶段
7. Store and Query:
8. Transaction: 
   * Atomicity
   * Consistency
   * durability
9. Structure:
   * Client
   * Application server
   * database system
10. Data mining and Information retrieval
11. Other Database schema
12. History:
    * 穿孔卡片
    * 磁带存储
    * 硬盘存储 <a href=./Material/codd[1970].pdf>(Codd[1970] 提出了关系型数据库)</a>
    * 网状和层次型数据库使用，关系型数据库理论研究
    * SQL
    * web开发，世界互联网爆炸发展
    * ...

### Chapter02:

1. Structure:
   * relation=>table   
   * tuple=>row
   * attribute=>column
   * relation instance=>specific instance
2. Schema:
   * relation schema: as program language's datatype
   * instance: variable
3. Key: 
   * Distinct: 区分每一个元组
   * superkey: 属性的集合
   * candidate key：候选键
   * primary key: 主键，主要用来区分不同元组的候选码
   * foreign key: 一个关系模式可能在它的属性中包括另一个关系模式的主码
4. schema diagram:
5. Relational query language:
6. Relational Algebra:
   * 选择 σ
   * 投影  Π
   * 自然连接 ⋈
   * 笛卡尔积 ×
   * 并 ∪

### Chapter06:

1. Relational Algebra:(`SQL 术语`)
   * select: 选择出满足给定谓词的元组，相当于`where`
   * project: 返回组为参数的关系，但是把某些属性排除在外
   * union: 将两个相容的关系并起来（同元，并且属性数目必须对应相等）
   * difference: 差
   * Cartesian-product(join): 返回一个笛卡尔积
   * rename: ρ<sub>x</sub>(E)将关系代数表达式更名为x（一元），如果是多元需要多个x
   * intersection: ∩
   * natural join: 根据都出现的属性名连接两个关系
   * outer join: 可以处理缺失的信息
   * aggregate function: sum, avg, count, min, max
2. Tuple Relational calculus:
3. domain relational calculus: 
   * 两个非过程化语言：代表了关系查询原因呢所需要的基本能力

### Papers:

#### <a href=./Material/Early_History_of_SQL.pdf>Early History of SQL:</a>

1. Ted Codd was designing two Relational Language(Relational Algebra and Relational Calculus).
2. Square: based on the notion of mapping but difficult to type
3. Sequel: declarative language
   * Criticisms: nulls value and so on
   * Philosophy: People could walk up and use it

## [In the Course:](https://www.youtube.com/watch?v=oeYBdghaIjc&list=PLSE8ODhjZXjbohkNBWQs_otTrBTrjyohi&index=1&ab_channel=CMUDatabaseGroup)

How to Use a database: CMU 95-703(build and administrate) & CMU 15-415/615(db applications)

### Overview

* Relational databases

* storage

* execution 

* concurrency control

* recovery

* distributed databases

* potpourri

### Course logistics

* In Piazza
* <a href=../Resources/数据库系统概念_原书第6版.pdf>textbook: Database System concepts</a>
* ALL Five homework: first is SQL assignment
* Build storage manager from scratch: Each project builds on the previous one
* Use C++ 17: write and debug(There is a self exam on Piazza)
* We will work on BusTub: Source Code is on GitHub
* Advanced Class: 15-721

### Database

* extremely important
* Organized collection of inter-related data that models some aspects of the real world
* store in CSV files that we manage in our own code
* Use a separate file per entity
* Why we use database?
  * To ensure the atomic
  * The security
  * and so on
  * How to query quickly?
  * A exact one database needs a lot of API for various languages
  * Two threads try to write to the same file at the same time ?
  * When program crashes
  * Every data can be stored in the database
* DBMS is designed to allow the definition, creation, querying, update, and administration of databases
* the one underneath Everything is database 

### Relational Model

* Ted Codd[1970] creates relational database concept
* Data models: collection of concepts for describing the data in a database
* Schema: description of a particular collection of data, using a given data model
* Models: **relational**, k/v, graph, documents, column-family, Array/Matrix(Machine Learning), hierarchical, network



* Structure: definition of relations and their contents

* Integrity: ensure the database's contents satisfy constraints

* Manipulation: how to access and modify a database's contents

* Relation: unordered set 

* tuple: a set of attribute values (or domain)     NULL is a number, value are atomic/scalar

  n-ary Relation = table with n columns

* primary key: uniquely identifies a single tuple (We may create an id attributes as a primary key)

* foreign key: specifies that an attribute from one relation has to map to a tuple in another relation

* DML: how to store and retrieve information from a database

### Relational Algebra(Procedural DML)

* Relational calculus(Non-procedural DML) (we don't need this)

  

Based on set algebra, we can chain operators together to create more complex operations.

* Select: choose a subset of the tuples from a relation that satisfies a selection predicate 

  `select ... where`

* Projection: Generate a relation with tuples that contains only the specified attributes 

  `select 'this' where`

* Union: Generate a relation that contains all tuples that appear in either only one or both input relations

  `(select * from r) UNION ALL (select * from f)`

* Intersection: Generate a relation that contains only the tuples that appear in both input relations

  `(select * from r) INTERSECT (select * from s)`

* Difference: 

  `(select * from r) EXCEPT (select * from s)`

* Product: All possible combinations of tuples from the input relations

  `select * from R CROSS JOIN S`

  `select * from R, S`

* Join: Natural Join, contains all tuples that are a combination of two tuples with a common value for one or more attributes

  `select * from R NATURAL JOIN S`

* others: rename, assignment, duplicate elimination, aggregation, sorting, division

* QUERIES: SQL is the *de facto* standard

**The execution order of these operators is very important.**

### Conclusion

* Databases are ubiquitous.
* Relational algebra defines the primitives for processing queries on a relational database.
* We will see relational algebra again when we talk about query optimization + execution.

## Exercise

### <a href=./Material/Chapter01_answer.pdf>Chapter01</a>

1. disadvantages: Build one needs a lot resources, complexity of the data base may result in poor performance
2. ..
3. 1. define high level requirements of the enterprise
   2. define a model
   3. define the integrity
   4. define the physical level
   5. for each known problem  define a user interface
   6. create the database
4. ...
5. ...
6. The queries in the web are specified by providing a list of keywords with no specific syntax. And you will get a series of URLS, along wit snippets of information about the content of the URLS; Database queries have a specific syntax allowing complex queries to be specified. And in a relational database, you will get a table.

### <a href=./Material/Chapter02_answer.pdf>Chapter02</a>

1. person-name, person-name, company-name

2. ...

3. ...

4. No, there is a possibility.

5. ...

6. a, for each student who takes at least one course in 2009, display the students information along with the information about what courses the student took. The attributes in the result are:

   `ID, name, dept_name, tot_cred, course_id section_id, semester, year, grade`

   b, same as a; selection can be done before the join operation

   c, provide a list of consisting of all students who took any course in the university

7. ...

8. ...

### <a href=./Material/Chapter06_answer.pdf>Chapter06</a>

1. ...
2. ...
3. ...
4. ...
5. ...
6. ...
7. ...
8. ...
9. ...