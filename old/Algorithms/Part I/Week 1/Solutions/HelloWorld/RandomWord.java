/*******************************************
 * Author: Huang
 * Date: 22.01.11
 * Website: https://huang-feiyu.github.io
 * Description: RandomWord.java for homework
 *******************************************/

import edu.princeton.cs.algs4.StdIn;
import edu.princeton.cs.algs4.StdOut;
import edu.princeton.cs.algs4.StdRandom;

/* Methods we should use:
    * StdIn.readString(): reads and returns the next string from standard input.
    * StdIn.isEmpty(): returns true if there are no more strings available on standard input, and false otherwise.
    * StdOut.println(): prints a string and terminating newline to standard output. It’s also fine to use System.out.println() instead.
    * StdRandom.bernoulli(p): returns true with probability p and false with probability 1−p.
 */

public class RandomWord {
    public static void main(String[] args) {
        String readIn;
        int index = 0;
        String champion = "";
        while (!StdIn.isEmpty()) {
            readIn = StdIn.readString();
            index++;
            if (StdRandom.bernoulli(1.0 / index)) {
                champion = readIn;
            }
        }
        StdOut.println(champion);
    }
}
