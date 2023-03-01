/*****************************************************************
 * Author: Huang
 * Date: 22.01.13
 * Website: https://huang-feiyu.github.io
 * Description: Deque.java for algs4 homework-Queue
 *****************************************************************/

import java.util.Iterator;
import java.util.NoSuchElementException;

import edu.princeton.cs.algs4.StdOut;

public class Deque<Item> implements Iterable<Item> {
  private int sz; // size of the deque
  private Node first; // top of deque
  private Node last; // bottom of deque

  private class Node {
    private final Item item;
    private Node prev;
    private Node next;

    public Node(Item item) {
      this.item = item;
      this.prev = null;
      this.next = null;
    }
  }

  // construct an empty deque
  public Deque() {
    this.sz = 0;
    this.first = null;
    this.last = null;
  }

  // is the deque empty?
  public boolean isEmpty() {
    return sz == 0;
  }

  // return the number of items on the deque
  public int size() {
    return sz;
  }

  // add the item to the front
  public void addFirst(Item item) {
    if (item == null) throw new IllegalArgumentException();
    Node node = new Node(item);
    if (isEmpty()) {
      first = node;
      last = first;
    } else {
      first.prev = node;
      node.next = first;
      first = node;
    }
    this.sz++;
  }

  // add the item to the back
  public void addLast(Item item) {
    if (item == null) throw new IllegalArgumentException();
    Node node = new Node(item);
    if (isEmpty()) {
      first = node;
      last = first;
    } else {
      last.next = node;
      node.prev = last;
      last = node;
    }
    this.sz++;
  }

  // remove and return the item from the front
  public Item removeFirst() {
    if (isEmpty()) throw new NoSuchElementException();
    Item item = first.item;
    if (size() == 1) {
      first = null;
      last = null;
    } else {
      first.next.prev = null;
      first = first.next;
    }
    this.sz--;
    return item;
  }

  // remove and return the item from the back
  public Item removeLast() {
    if (isEmpty()) throw new NoSuchElementException();
    Item item = last.item;
    if (size() == 1) {
      first = null;
      last = null;
    } else {
      last.prev.next = null;
      last = last.prev;
    }
    this.sz--;
    return item;
  }

  // return an iterator over items in order from front to back
  public Iterator<Item> iterator() {
    return new DequeIterator();
  }

  // an iterator, doesn't implement remove() since it's optional
  private class DequeIterator implements Iterator<Item> {
    private Node current = first;

    @Override
    public boolean hasNext() {
      return current != null;
    }

    @Override
    public void remove() {
      throw new UnsupportedOperationException();
    }

    @Override
    public Item next() {
      if (!hasNext()) throw new NoSuchElementException();
      Item item = current.item;
      current = current.next;
      return item;
    }
  }

  // unit testing (required)
  public static void main(String[] args) {
    int n = 10;
    Deque<Integer> queue = new Deque<>();
    for (int i = 0; i < n; i++) {
      if (i % 2 == 0) {
        queue.addLast(i);
      } else {
        queue.addFirst(i);
      }
    }
    for (int a : queue) {
      StdOut.print(a);
    }
    StdOut.println();
    queue.removeFirst();
    queue.removeFirst();
    for (int a : queue) {
      StdOut.print(a);
    }
    StdOut.println();
    queue.addFirst(9);
    queue.removeLast();
    for (int a : queue) {
      StdOut.print(a);
    }
    // StdOut.println();
    StdOut.println(queue.sz);
  }
}
