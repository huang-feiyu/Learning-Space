/*****************************************************************
 * Author: Huang
 * Date: 22.01.13
 * Website: https://huang-feiyu.github.io
 * Description: Permutation.java for algs4 homework-Queue
 *****************************************************************/

import edu.princeton.cs.algs4.StdOut;

public class Permutation {
  public static void main(String[] args) {
    int k = Integer.parseInt(args[0]);
    RandomizedQueue<String> randQueue = new RandomizedQueue<>();
    for (int i = 1; i < args.length; i++) {
      randQueue.enqueue(args[i]);
    }
    int count = 0;
    for (String string : randQueue) {
      if (count < k) {
        StdOut.println(string);
        count++;
      } else {
        break;
      }
    }
  }
}
