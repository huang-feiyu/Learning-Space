/*****************************************************************
 * Author: Huang
 * Date: 22.01.16
 * Website: https://huang-feiyu.github.io
 * Description: Solver.java for algs4 homework-8Puzzle
 *****************************************************************/

import edu.princeton.cs.algs4.In;
import edu.princeton.cs.algs4.MinPQ;
import edu.princeton.cs.algs4.Stack;
import edu.princeton.cs.algs4.StdOut;

public class Solver {
  private SearchNode currentNode;
  private SearchNode twinCurrentNode;
  private Stack<Board> solution;

  private class SearchNode implements Comparable<SearchNode> {
    private final Board board;
    private final SearchNode preNode;
    private int moves;
    private final int priority;

    public SearchNode(Board board, SearchNode preNode) {
      this.board = board;
      this.preNode = preNode;
      if (preNode == null) {
        moves = 0;
      } else {
        this.moves = preNode.moves + 1;
      }
      this.priority = moves + board.manhattan();
    }

    @Override
    public int compareTo(SearchNode node) {
      return Integer.compare(this.priority, node.priority);
    }
  }

  // find a solution to the initial board (using the A* algorithm)
  public Solver(Board initial) {
    if (initial == null) throw new IllegalArgumentException();
    solution = new Stack<>();
    // A fact: boards are divided into two equivalence classes with respect to reachability
    currentNode = new SearchNode(initial, null);
    twinCurrentNode = new SearchNode(initial.twin(), null);
    MinPQ<SearchNode> PQ = new MinPQ<>();
    MinPQ<SearchNode> twinPQ = new MinPQ<>();
    PQ.insert(currentNode);
    twinPQ.insert(twinCurrentNode);
    // A* algorithm: Best first
    while (!PQ.isEmpty() && !twinPQ.isEmpty()) {
      currentNode = PQ.delMin();
      if (currentNode.board.isGoal()) break;
      insertNeighbor(currentNode, PQ);

      twinCurrentNode = twinPQ.delMin();
      if (twinCurrentNode.board.isGoal()) break;
      insertNeighbor(twinCurrentNode, twinPQ);
    }
  }

  // put neighbor into priority queue
  private void insertNeighbor(SearchNode searchNode, MinPQ<SearchNode> pq) {
    for (Board neighbor : searchNode.board.neighbors()) {
      // preNode(also a neighbor) should not be inserted again
      if (searchNode.preNode == null || !neighbor.equals(searchNode.preNode.board))
        pq.insert(new SearchNode(neighbor, searchNode));
    }
  }

  // is the initial board solvable?
  public boolean isSolvable() {
    return currentNode.board.isGoal();
  }

  // min number of moves to solve initial board; -1 if unsolvable
  public int moves() {
    return isSolvable() ? currentNode.moves : -1;
  }

  // sequence of boards in the shortest solution; null if unsolvable
  public Iterable<Board> solution() {
    if (!isSolvable()) return null;
    SearchNode node = currentNode;
    while (node != null) {
      solution.push(node.board);
      node = node.preNode;
    }
    return solution;
  }

  // test client (see below)
  public static void main(String[] args) {
    // create initial board from file
    In in = new In(args[0]);
    int n = in.readInt();
    int[][] tiles = new int[n][n];
    for (int i = 0; i < n; i++) for (int j = 0; j < n; j++) tiles[i][j] = in.readInt();
    Board initial = new Board(tiles);

    // solve the puzzle
    Solver solver = new Solver(initial);

    // print solution to standard output
    if (!solver.isSolvable()) StdOut.println("No solution possible");
    else {
      StdOut.println("Minimum number of moves = " + solver.moves());
      for (Board board : solver.solution()) StdOut.println(board);
    }
  }
}
