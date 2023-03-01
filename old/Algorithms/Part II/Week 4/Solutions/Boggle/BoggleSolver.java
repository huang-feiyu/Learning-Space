/******************************************************************************
 * Author: Huang
 * Date: 22.02.02
 * Website: https://huang-feiyu.github.io
 * Description: BoggleSolver.java for algs4 homework-Boggle
 ******************************************************************************/

import edu.princeton.cs.algs4.In;
import edu.princeton.cs.algs4.Bag;
import edu.princeton.cs.algs4.StdOut;
import edu.princeton.cs.algs4.TrieSET;

import java.util.HashSet;

public class BoggleSolver {
  private final TrieSET dict;
  private HashSet<String> validWords;

  // Initializes the data structure using the given array of strings as the dictionary.
  public BoggleSolver(String[] dictionary) {
    dict = new TrieSET();
    for (String word : dictionary)
      dict.add(word);
  }

  // Returns the set of all valid words in the given Boggle board, as an Iterable.
  public Iterable<String> getAllValidWords(BoggleBoard board) {
    int rows = board.rows();
    int cols = board.cols();
    validWords = new HashSet<>();
    boolean[] marked = new boolean[rows * cols];
    for (int i = 0; i < rows * cols; i++) {
      // 原先使用二维数组，因为每次遍历需要重新设置访问表，故援引:https://github.com/LancelotGT/algs4/blob/master/boggle/BoggleSolver.java
      // 简言之：很难debug，抄了一下……
      dfs(board, i, "", 0, marked.clone());
    }
    Bag<String> clone = new Bag<>();
    for (String word : validWords)
      clone.add(word);
    return clone;
  }

  // private method to search for valid words and add to a list
  private void dfs(BoggleBoard board, int v, String curr, int d, boolean[] marked) {
    int cols = board.cols();
    marked[v] = true;
    String temp = curr + board.getLetter(v / cols, v % cols); // weird

    // if the letter is Q, add a U to the last letter
    boolean isQ = board.getLetter(v / cols, v % cols) == 'Q';
    if (isQ) temp = temp + "U";

    if (d >= 2) {
      if (dict.contains(temp))
        validWords.add(temp);
      else if (dict.keysWithPrefix(temp).toString().equals(""))
        return;
    }

    Bag<Integer> adjs = adj(board, v);
    for (int i : adjs)
      if (!marked[i])
          dfs(board, i, temp, isQ ? d + 2 : d + 1, marked.clone());
  }

  // Find all the indexes adjacent to v and return a bag of integers
  private Bag<Integer> adj(BoggleBoard board, int v) {
    int rows = board.rows();
    int cols = board.cols();
    Bag<Integer> adjacents = new Bag<>();
    int x = v % cols;
    int y = v / cols;
    if (x + 1 <= cols - 1) adjacents.add(y * cols + x + 1);
    if (x - 1 >= 0) adjacents.add(y * cols + x - 1);
    if (y - 1 >= 0) adjacents.add((y - 1) * cols + x);
    if (y + 1 <= rows - 1) adjacents.add((y + 1) * cols + x);
    if (x + 1 <= cols - 1 && y + 1 <= rows - 1) adjacents.add((y + 1) * cols + x + 1);
    if (x - 1 >= 0 && y + 1 <= rows - 1) adjacents.add((y + 1) * cols + x - 1);
    if (x + 1 <= cols - 1 && y - 1 >= 0) adjacents.add((y - 1) * cols + x + 1);
    if (x - 1 >= 0 && y - 1 >= 0) adjacents.add((y - 1) * cols + x - 1);
    return adjacents;
  }

  // Returns the score of the given word if it is in the dictionary, zero otherwise.
  public int scoreOf(String word) {
    if (dict.contains(word)) {
      int len = word.length();
      if (len < 3) return 0;
      else if (len >= 8) return 11;
      switch (len) {
        case 5: return 2;
        case 6: return 3;
        case 7: return 5;
        default: return 1; // 3,4
      }
    }
    return 0;
  }

  public static void main(String[] args) {
      In in = new In(args[0]);
      String[] dictionary = in.readAllStrings();
      BoggleSolver solver = new BoggleSolver(dictionary);
      BoggleBoard board = new BoggleBoard(args[1]);
      int score = 0;
      for (String word : solver.getAllValidWords(board)) {
          StdOut.println(word);
          score += solver.scoreOf(word);
      }
      StdOut.println("Score = " + score);
  }
}
