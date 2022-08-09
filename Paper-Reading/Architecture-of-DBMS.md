# Architecture of a Database System

> [fntdb07-architecture](https://dsf.berkeley.edu/papers/fntdb07-architecture.pdf)
> uniquely provides a high-level view of how relational
> database management systems (RDBMS) work.

In this paper, we attempt to capture the main architectural aspects
of modern database systems.

## Introduction

![Main Component](https://user-images.githubusercontent.com/70138429/183296019-2f6672f8-1182-4278-a72a-9f61821fa4da.png)

A typical query's life:
1. From client to server, establish a connection to get SQL stmt via
*Client Communication Manager*.
2. DBMS assign a thread of computation and do stuff of admission
control via *Process Manager*.
3. Process SQL stmt and generate a query plan via *Relational Query
Manager*.
4. According to the query plan, make calls to fetch data from the
DBMS's *Transaction Storage Manager*, which ensure the ACID property.
5. Return to client and start another cyclely.

There are several other shared components in the database system.
