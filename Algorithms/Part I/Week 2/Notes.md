### Week 2

[TOC]

##### Stacks

* Stack: LIFO
  * `push`
  * `pop`
* `linked-list` implementation
  * inner class: `Node`
  * memory: 40N
* `array` implementation
  * must assign size

##### resizing arrays

* if array is full, create a new array of twice the size, and copy items
  * $3N=O(N)$
  * 平摊分析
* if array is one quarter of original size, create a new array of half the size, and copy items
* memory: 8N~32N

Linked-list or array is a tradeoff.

##### Queue

* Queue: FIFO
* `linked-list` implementation
  * inner class: `Node`
*  `array` implementation

##### Generics

> We need stack for multiple kinds of type.

```java
Stack<Apple> s = new Stack<Apple>();
// <{type parameter}>
```

There is no generics array in Java, so:

```java
a = (Item[]) new Object[capacity];
```

##### Iteration

* Iterator
  * `hasNext()`: bool
  * `Next()`: T

```java
for (String s : stack) // foreach
    StdOut.println(s)
```

##### Applications

> Don't use a library until you understand its API.

Java原生库的类常常过于臃肿，我们只需要一些方法，同时经验不足的Programmer很难评估性能。

* Stack
  * Arithmetic expression evaluation
  * Parse expression
  * Undo operation

##### Sorting Introduction

`sort()` calls back `compareTo()`

Java use `interface Comparable<T>` to implement `compareTo()`

...

后面太基础了，就不做笔记了。
