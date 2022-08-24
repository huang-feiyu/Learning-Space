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

## Process Models

Consider a simplified framework: A one-processing system supporting thread.

Terminologies:

* *OS Process*
* *OS Thread*
* *Lightweight Thread Package*: An **application-level** construct that supports multiple
  threads within a single OS process.
* *DBMS Client*: JDBC, ODBC...
* *DBMS Worker*:  The thread working for client in DBMS. (1:1 mapping *Worker* & *Client*)

### Lightweight Threads

DBMS normally implement their own lightweight thread package, which replace the
role of the OS threads.

1. *process per DBMS worker*
   * Pro: adapt to system
   * Con: more memory; shared memory issue
2. *thread per DBMS worker*
   * Pro: scales well; efficient
   * Con: hard to debug; no OS support; some shared memory issue
3. *process pool* (variant of *1*)
   * Pro: pros of *1*; better memory usage
   * Con: shared memory issue

For shared data, we need to use **various buffers** to implement a basic query.

* *Disk I/O buffers* (Interrupts: DB I/O Requests; Log I/O Requests)
* *Client communication buffers*

### Admission Control

1. Limitation to client connections (Some DBMS do not have this, who assumes it
  is implemented by application or other)
2. Whether to delay a query, to use less resource to execute query, to add
  limitations... Implemented in core DBMS relational query processor.

---

感觉只能获得一个模糊的印象, 建议看[PingCap Paper Reading](https://www.bilibili.com/video/BV1tE411B7Q2).

