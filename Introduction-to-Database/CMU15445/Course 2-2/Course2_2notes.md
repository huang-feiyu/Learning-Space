# CMU-154-45: 

## Before this course:

* Required Reading:  <a href=../Resources/数据库系统概念_原书第6版.pdf>Chapters 7-8</a>

### Papers:



## [In the Course:](https://www.youtube.com/watch?v=guOyZBnSKXg&list=PLSE8ODhjZXjYutVzTeAds8xUt1rcmyT7x&index=5&ab_channel=CMUDatabaseGroup)

### Normal Forms

##### Review
* Now that we know how to derive more FDs, we can then:
    * Search for "bad" FDs
    * If there are such, then decompose the table into two tables, repeat for
      the sub-tables
    * When done, the database schema is normalized

##### Definition
A normal form is a characterization aof a decomposition in terms of the
properties that satisfies when putting the relations back together.
(Also called the "universal relation")
* properties:
    * Lossless joins
    * Dependency Preservation
    * Redundancy Avoidance

##### History
* Ted Codd[1970]: 1NF
* Codd[1971]: 2NF, 3NF
* Code[1974]: BCNF

##### Lists
From top to bottom, more restrictive:
* 1NF: All Tables are Flat
* 2NF: Good Enough
* **3NF**: Most Common
* **BCNF**: Most Common
* 4NF, 5NF: textbook
* 6NF: Most people never need this
* Others: People do not care about

##### Normal Forms
* 1NF
    * All types must be atomic
    * No repeating groups
* 2NF
    * 1NF and non-key attributes fully depend on the candidate key
* BCNF
    * guarantees no redundancies and no lossless joins (but not DP)
    * A relation R with FD set F is in BCNF if all non-trivial X->Y in F+
      ===> X->R(i.e. X is a super key)
    * Given a schema R and a set of FDs F, we can always decompose R into
      {R1,...,Rn} such that {R1,...,Rn} are in BCNF; The decompositions are lossless
    * but some BCNF decompositions might lose dependencies: When we decompose
      some of Relation into BCNF realtions, then we join the single realtions we may violate the first place dependencies
    * Algorithm
* 3NF
    * preserves dependencies but may have some anomalies
    * A realtion R with FD set F is in 3NF if for every X->Y in F+:
      ====> X->Y is trivial, or ====> X is a super key, or ====> Y is part of candidate key
    * Algorithm

##### BCNF vs. 3NF
* BCNF
    * No anomalies, but may lose some FDs
    * In practice, this is what you want
* 3NF
    * Keeps all FDs, but may have some anomalies
    * You usually get this when you convert an ER diagram to SQL

##### Confession
* The normal forms is usuallly not how people design databases
* Instead, people usually think in terms of OOP

### Conclusion
* You should know about normal forms. They exist.
* There is no magic formula to determine whay is the right amount of
  normalization for an application

## Exercise

[Homework1-2](../exercise/homework1/hw1-clean.pdf)

### Question I
* (a) 
    * i   Yes
    * ii  Yes
    * iii No
    * iv  No
    * v   Yes
    * vi  Yes
* (b)
    * answer: No
    * reason: Because there is only one instance

### Question 2
* (a)
    * answer: iv
* (b)
    * i   Yes
    * ii  No
    * iii Yes
    * iv  Yes
    * v   Yes
    * vi  No
* (c)
    * answer: True
* (d)
    * answer: False

### Question 3
* (a)
    * answer: {A, B, C, D}
* (b)
    * i   False
    * ii  True
* (c)
    * i   False
    * ii  True
* (d)
    * i   True
    * ii  True

### Question 4
* (a)
    * answer: {P, S}, {P, Q}, {R, S}, {Q, R}
* (b)
    * answer: No
* (c)
    * i   False
    * ii  False
    * iii False
    * iv  True 
    * v   True
* (d)
    * answer: Yes
* (e)
    * i   True
    * ii  False
    * iii False
    * iv  False
    * v   False
* (f)
    * answer: {P, Q, R, S}
* (g)
    * answer: {P, Q}, {Q, S}, {R, S}
