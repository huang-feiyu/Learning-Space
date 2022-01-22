/******************************************************************************
 * Author: Huang
 * Date: 22.01.22
 * Website: https://huang-feiyu.github.io
 * Description: Outcast.java for algs4 homework-WordNet
 ******************************************************************************/

import edu.princeton.cs.algs4.In;
import edu.princeton.cs.algs4.StdOut;

public class Outcast {
  private final WordNet wordNet;

  // constructor takes a WordNet object
  public Outcast(WordNet wordnet) {
    if (wordnet == null) throw new IllegalArgumentException();
    wordNet = wordnet;
  }

  // given an array of WordNet nouns, return an outcast
  public String outcast(String[] nouns) {
    if (nouns == null) throw new IllegalArgumentException();
    int maxDis = 0;
    String outString = nouns[0];
    for (String candinate : nouns) {
      int dist = 0;
      for (String noun : nouns)
        dist += wordNet.distance(candinate, noun);
      if (dist > maxDis) {
        outString = candinate;
        maxDis = dist;
      }
    }
    return outString;
  }

  // see test client below
  public static void main(String[] args) {
    WordNet wordnet = new WordNet(args[0], args[1]);
    Outcast outcast = new Outcast(wordnet);
    for (int t = 2; t < args.length; t++) {
      In in = new In(args[t]);
      String[] nouns = in.readAllStrings();
      StdOut.println(args[t] + ": " + outcast.outcast(nouns));
    }
  }
}
