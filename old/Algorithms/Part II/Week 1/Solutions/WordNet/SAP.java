/******************************************************************************
 * Author: Huang
 * Date: 22.01.22
 * Website: https://huang-feiyu.github.io
 * Description: SAP.java for algs4 homework-WordNet
 ******************************************************************************/

import edu.princeton.cs.algs4.In;
import edu.princeton.cs.algs4.Queue;
import edu.princeton.cs.algs4.StdIn;
import edu.princeton.cs.algs4.StdOut;
import edu.princeton.cs.algs4.Digraph;
import edu.princeton.cs.algs4.BreadthFirstDirectedPaths;

public class SAP {
  private static final int LENGTH = 0;
  private static final int ANCESTOR = 1;
  private final Digraph graph;

  // constructor takes a digraph (not necessarily a DAG)
  public SAP(Digraph G) {
    if (G == null) throw new IllegalArgumentException("Null digraph G");
    graph = new Digraph(G); // a copy of G for NOW
  }

  // length of the shortest ancestral path between v and w; -1 if no such path
  public int length(int v, int w) {
    if (v < 0 || w < 0) throw new IllegalArgumentException();
    BreadthFirstDirectedPaths pathsV = new BreadthFirstDirectedPaths(graph, v);
    BreadthFirstDirectedPaths pathsW = new BreadthFirstDirectedPaths(graph, w);
    return findSAP(pathsV, pathsW, LENGTH);
  }

  // a common ancestor of v and w that participates in the shortest ancestral path; -1 if no such path
  public int ancestor(int v, int w) {
    if (v < 0 || w < 0) throw new IllegalArgumentException();
    BreadthFirstDirectedPaths pathsV = new BreadthFirstDirectedPaths(graph, v);
    BreadthFirstDirectedPaths pathsW = new BreadthFirstDirectedPaths(graph, w);
    return findSAP(pathsV, pathsW, ANCESTOR);
  }

  // length of the shortest ancestral path between any vertex in v and any vertex in w; -1 if no such path
  public int length(Iterable<Integer> v, Iterable<Integer> w) {
    if (v == null || w == null)
      throw new IllegalArgumentException();
    BreadthFirstDirectedPaths pathsV = new BreadthFirstDirectedPaths(graph, v);
    BreadthFirstDirectedPaths pathsW = new BreadthFirstDirectedPaths(graph, w);
    return findSAP(pathsV, pathsW, LENGTH);
  }

  // a common ancestor that participates in the shortest ancestral path; -1 if no such path
  public int ancestor(Iterable<Integer> v, Iterable<Integer> w) {
    if (v == null || w == null) throw new IllegalArgumentException();
    BreadthFirstDirectedPaths pathsV = new BreadthFirstDirectedPaths(graph, v);
    BreadthFirstDirectedPaths pathsW = new BreadthFirstDirectedPaths(graph, w);
    return findSAP(pathsV, pathsW, ANCESTOR);
  }

  // find SAP: Shortest ancestral path (use BFS to find all paths)
  private int findSAP(BreadthFirstDirectedPaths pathsV,
                      BreadthFirstDirectedPaths pathsW, int flag) {
    Queue<Integer> ancestors = new Queue<>();
    // traverse to find possible ancestor
    for (int i = 0; i < graph.V(); i++) {
      if (pathsV.hasPathTo(i) && pathsW.hasPathTo(i)) ancestors.enqueue(i);
    }

    int minDis = Integer.MAX_VALUE;
    int minAncestor = -1;
    // traverse to find min path in possible ancestors
    for (int ancestor : ancestors) {
      int tempDis = pathsV.distTo(ancestor) + pathsW.distTo(ancestor);
      if (tempDis < minDis) {
        minDis = tempDis;
        minAncestor = ancestor;
      }
    }
    // if there is no SAP, minDis = -1
    minDis = minDis == Integer.MAX_VALUE ? -1 : minDis;

    // return length if flag equals 0; else return ancestor
    return flag == 0 ? minDis : minAncestor;
  }

  // do unit testing of this class
  public static void main(String[] args) {
    In in = new In(args[0]);
    Digraph G = new Digraph(in);
    SAP sap = new SAP(G);
    while (!StdIn.isEmpty()) {
      int v = StdIn.readInt();
      int w = StdIn.readInt();
      int length = sap.length(v, w);
      int ancestor = sap.ancestor(v, w);
      StdOut.printf("length = %d, ancestor = %d\n", length, ancestor);
    }
  }
}
