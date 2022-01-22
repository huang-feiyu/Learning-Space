/******************************************************************************
 * Author: Huang
 * Date: 22.01.22
 * Website: https://huang-feiyu.github.io
 * Description: WordNet.java for algs4 homework-WordNet
 ******************************************************************************/

import edu.princeton.cs.algs4.Bag;
import edu.princeton.cs.algs4.Digraph;
import edu.princeton.cs.algs4.DirectedCycle;
import edu.princeton.cs.algs4.In;
import edu.princeton.cs.algs4.ST;
import edu.princeton.cs.algs4.StdIn;
import edu.princeton.cs.algs4.StdOut;

public class WordNet {
  private final SAP sap;
  private final ST<Integer, String> idToSynset; // id-synset: one to one
  private final ST<String, Bag<Integer>> nounToIds; // a noun can matches multiple num

  // constructor takes the name of the two input files
  public WordNet(String synsets, String hypernyms) {
    if (synsets == null || hypernyms == null)
      throw new IllegalArgumentException();
    In synsetsIn = new In(synsets);
    In hypernymsIn = new In(hypernyms);
    this.idToSynset = new ST<>();
    this.nounToIds = new ST<>();

    // read synsets
    while (synsetsIn.hasNextLine()) {
      String[] splitSynsets = synsetsIn.readLine().split(",");
      // read nouns
      for (String noun : splitSynsets[1].split(" ")) {
        Bag<Integer> idBag = new Bag<>();
        if (nounToIds.contains(noun)) idBag = nounToIds.get(noun);
        idBag.add(Integer.parseInt(splitSynsets[0]));
        nounToIds.put(noun, idBag); // update: add new id to noun
      }
      // add id:synset
      idToSynset.put(Integer.parseInt(splitSynsets[0]), splitSynsets[1]);
    }

    // generate graph
    Digraph digraph = new Digraph(idToSynset.size());
    while (hypernymsIn.hasNextLine()) {
      String[] splitHypernyms = hypernymsIn.readLine().split(",");
      int source = Integer.parseInt(splitHypernyms[0]);
      for (int i = 1; i < splitHypernyms.length; i++) {
        digraph.addEdge(source, Integer.parseInt(splitHypernyms[i]));
      }
    }
    DirectedCycle cycle = new DirectedCycle(digraph);
    if (cycle.hasCycle() || !rootGraph(digraph))
      throw new IllegalArgumentException();
    this.sap = new SAP(digraph);
  }

  // return root == 1 of graph
  private boolean rootGraph(Digraph digraph) {
    int num = 0;
    for (int i = 0; i < digraph.V(); i++) {
      if (!digraph.adj(i).iterator().hasNext()) {
        num++;
        if (num > 1) return false;
      }
    }
    return num == 1;
  }

  // returns all WordNet nouns
  public Iterable<String> nouns() {
    return nounToIds.keys();
  }

  // is the word a WordNet noun?
  public boolean isNoun(String word) {
    if (word == null) throw new IllegalArgumentException();
    return nounToIds.contains(word);
  }

  // distance between nounA and nounB (defined below)
  public int distance(String nounA, String nounB) {
    if (!isNoun(nounA) || !isNoun(nounB)) throw new IllegalArgumentException();
    return sap.length(nounToIds.get(nounA), nounToIds.get(nounB));
  }

  // a synset (second field of synsets.txt) that is the common ancestor of nounA and nounB
  // in the shortest ancestral path (defined below)
  public String sap(String nounA, String nounB) {
    if (!isNoun(nounA) || !isNoun(nounB)) throw new IllegalArgumentException();
    int ancestor = sap.ancestor(nounToIds.get(nounA), nounToIds.get(nounB));
    return idToSynset.get(ancestor);
  }

  // do unit testing of this class
  public static void main(String[] args) {
    WordNet wordNet = new WordNet(args[0], args[1]);
    while (!StdIn.isEmpty()) {
      String v = StdIn.readString();
      String w = StdIn.readString();

      if (!wordNet.isNoun(v)) {
        StdOut.println(v + ": is not noun");
        continue;
      }
      if (!wordNet.isNoun(w)) {
        StdOut.println(w + ": is not noun");
        continue;
      }
      int dist = wordNet.distance(v, w);
      String ancestor = wordNet.sap(v, w);
      StdOut.printf("Distance is %d, ancestor is %s\n", dist, ancestor);
    }
  }
}
