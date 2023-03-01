/*****************************************************************
 * Author: Huang
 * Date: 22.01.13
 * Website: https://huang-feiyu.github.io
 * Description: RandomizedQueue.java for algs4 homework-Queues
 *****************************************************************/

import edu.princeton.cs.algs4.StdOut;
import edu.princeton.cs.algs4.StdRandom;

import java.util.Iterator;
import java.util.NoSuchElementException;

public class RandomizedQueue<Item> implements Iterable<Item> {
  private static final int INIT_CAPACITY = 2;
  private int sz;
  private Item[] queue;

  // construct an empty randomized queue
  public RandomizedQueue() {
    queue = (Item[]) new Object[INIT_CAPACITY];
    sz = 0;
  }

  // is the randomized queue empty?
  public boolean isEmpty() {
    return sz == 0;
  }

  // return the number of items on the randomized queue
  public int size() {
    return sz;
  }

  // add the item
  public void enqueue(Item item) {
    if (item == null) throw new IllegalArgumentException();
    if (sz == queue.length) resize(queue.length * 2);
    queue[sz] = item;
    this.sz++;
  }

  // remove and return a random item
  public Item dequeue() {
    if (isEmpty()) throw new NoSuchElementException();
    // get a uniform number in [0, sz)
    int randNum = StdRandom.uniform(sz);
    Item item = queue[randNum];
    queue[randNum] = null;
    exc(randNum, sz - 1);
    this.sz--;
    if (sz > 0 && sz == queue.length / 4) resize(queue.length / 2);
    return item;
  }

  // return a random item (but do not remove it)
  public Item sample() {
    if (isEmpty()) throw new NoSuchElementException();
    // get a uniform number in [0, sz)
    int randNum = StdRandom.uniform(sz);
    return queue[randNum];
  }

  // return an independent iterator over items in random order
  public Iterator<Item> iterator() {
    return new RandomizedQueueIterator();
  }

  // an iterator, doesn't implement remove() since it's optional
  private class RandomizedQueueIterator implements Iterator<Item> {
    private int current;
    private final Item[] randQueue;

    public RandomizedQueueIterator() {
      // init array and shuffle it
      randQueue = (Item[]) new Object[sz];
      for (int i = 0; i < sz; i++) {
        randQueue[i] = queue[i];
      }
      StdRandom.shuffle(randQueue);
      current = 0;
    }

    @Override
    public boolean hasNext() {
      return current < randQueue.length;
    }

    @Override
    public void remove() {
      throw new UnsupportedOperationException();
    }

    @Override
    public Item next() {
      if (!hasNext()) throw new NoSuchElementException();
      return randQueue[current++];
    }
  }

  // resize the array
  private void resize(int newSize) {
    Item[] copy = (Item[]) new Object[newSize];
    for (int i = 0; i < sz; i++) {
      copy[i] = queue[i];
    }
    queue = copy;
  }

  // exchange two elements
  private void exc(int a, int b) {
    Item temp = queue[a];
    queue[a] = queue[b];
    queue[b] = temp;
  }

  // unit testing (required)
  public static void main(String[] args) {
    int n = 5;
    RandomizedQueue<Integer> queue = new RandomizedQueue<Integer>();
    for (int i = 0; i < n; i++) queue.enqueue(i);
    for (int a : queue) {
      for (int b : queue) StdOut.print(a + "-" + b + " ");
      StdOut.println();
    }
  }
}
