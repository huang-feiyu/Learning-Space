### Week 6

[toc]

##### Hash Tables

* Basic Plan: Save items in a key-indexed table (index is a function of the key)
  * Hash function: Method for computing array index from key
  * *Space-time tradeoff*

```java
// work for all number in ±2^31-1
private int hash(Key key) {
    return (key.hashCode() & 0x7fffffff) % M);
}
```

###### Sperate chaining

* Collision: Two distinct keys hashing to same index
* Challenge: Deal with collisions efficiently

---

* Use an array of $M < N$ linked lists
  * Hash: map key to integer $i$ between $0$ and $M - 1$
  * Insert: put at front of $i^{th}$ chain (if not already there)
  * Search: need to search only $i^{th}$ chain
    * List is ordered: binary search
    * unordered: traverse
  * Typical: $M \sim N/5 \Rightarrow \text{constant-time ops}$ 

###### Linear probing

> Open addressing: When a new key collides, find next next empty slot, and put it there.

* Hash: Map key to integer $i$ between $0$ and $M-1$
* Insert: Put at table index $i$ if free; if not try $i+1, i+2, \text{etc.}$
* Search: Search table index $i$; if occupied but no match, try $i + 1, i+ 2, \text{etc.}$

Array size $M$ <font color=red>must be</font> greater than number of k-v pairs $N$

---

If cluster, new keys likely to hash into middle of big clusters.

###### Context

```java
// java 1.1: String hashCode()
public int hashCode() {
    int hash = 0;
    int skip = Math.max(1, length()/8);
    for (int i = 0; i < length(); i += skip)
        hash = s[i] + (37 * hash);
    return hash;
}
```

###### Application

* Set

> A collection of distinct keys.

```java
public class SET<Key extends Comparable<Key>>
```

* Dictionary
* Indexing
* Sparse Matrix-vector multiplication