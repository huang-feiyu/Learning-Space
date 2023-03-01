### Week 3

[TOC]

##### Merge Sort

###### merge-sort

> Divide and Conquer.

Basic Plan

* Divide array into two halves
* Recursively sort each half
* Merge two halves

Analysis

* time: $\displaystyle\frac{1}{2}N\lg N \sim N\lg N$

To reduce the use of memory

* Use insertion sort for small subarrays
* Stop if already sorted
* Eliminate the copy the auxiliary array

###### Bottom-up merge-sort

> No recursive at all.

Basic Plan

* Pass through array, merging subarrays of size 1
* Repeat for subarrays of size 2, 4, 8……

###### Complexity of sorting

计算复杂性：Computational complexity

比较排序的下界：$\lg(N!)\sim N\lg N$

归并上界的上界也是: $O(N\lg N)$

$\Rightarrow$ 归并排序是时间复杂度最低的比较算法

* 对于部分有序数组、重复值数组、特征数组，可能不需要$N\lg N$

###### Comparators

```java
public interface Comparator<Key>
```

Java system sort: 

```java
// 不同的排序策略
Arrays.sort(a, String.CASE_INSENSITIVE_ORDER);
Arrays.sort(a, Collator.getInstance(new Locale("es"));
Array.sort(a, new BritishPhoneBookOrder());
```

###### Stability

插入排序和(实现稳定的)归并排序是稳定的，不稳定的排序可能将相同值的原始相对顺序打乱。

[Collinear Points](./Solutions/Collinear Points)

##### Quick Sort

###### quick-sort

* Shuffle the array
* Partition, for some `j`
  * entry `a[j]` is in place
  * no larger entry to the left of `j`
  * no smaller entry to the right of `j`
* Sort each piece recursively

average time: $1.39N\lg N$

in place(with out extra space)

To accelerate algorithm:

* Insertion small subarrays
* Median of sample

###### Selection

选择第几小的数

* Quick-Select

  * Partition

  * Repeat in one subarray, depending on `j`; finished when `j` equals `k`

    $O(N)$

###### duplicate keys

[3-way partition](https://www.geeksforgeeks.org/3-way-quicksort-dutch-national-flag/)

###### System sorts

`java.util.Arrays.sort()`
