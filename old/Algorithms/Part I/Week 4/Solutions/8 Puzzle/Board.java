/*****************************************************************
 * Author: Huang
 * Date: 22.01.16
 * Website: https://huang-feiyu.github.io
 * Description: Board.java for algs4 homework-8Puzzle
 *****************************************************************/

import edu.princeton.cs.algs4.StdOut;

import java.util.ArrayList;
import java.util.NoSuchElementException;

public class Board {
  private static final int BLANK = 0; // 0 is not a tile
  private final int n; // the size of board (n * n grid)
  private int[][] tiles; // the board

  // create a board from an n-by-n array of tiles,
  // where tiles[row][col] = tile at (row, col)
  public Board(int[][] tiles) {
    if (tiles == null || tiles.length != tiles[0].length) {
      throw new IllegalArgumentException("Not a n*n grid");
    }
    if (tiles.length < 2) {
      throw new IllegalArgumentException("Illegal n");
    }
    this.n = tiles.length;
    this.tiles = new int[n][n];
    copyOf(tiles, this.tiles);
  }

  // string representation of this board
  public String toString() {
    StringBuilder s = new StringBuilder();
    s.append(n + "\n");
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        s.append(String.format("%2d ", tiles[i][j]));
      }
      s.append("\n");
    }
    return s.toString();
  }

  // board dimension n
  public int dimension() {
    return this.n;
  }

  // number of tiles out of place
  public int hamming() {
    int hamming = 0;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (tiles[i][j] != BLANK && tiles[i][j] != i * n + j + 1) {
          hamming++;
        }
      }
    }
    return hamming;
  }

  // sum of Manhattan distances between tiles and goal
  public int manhattan() {
    int manhattan = 0;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (tiles[i][j] != BLANK && tiles[i][j] != i * n + j + 1) {
          int row = (tiles[i][j] - 1) / n; // the value's row should be
          int col = (tiles[i][j] - 1) % n; // the value's col should be
          manhattan += Math.abs(row - i) + Math.abs(col - j);
        }
      }
    }
    return manhattan;
  }

  // is this board the goal board?
  public boolean isGoal() {
    return hamming() == 0;
  }

  // does this board equal y?
  public boolean equals(Object y) {
    if (y == null) return false;
    if (y == this) return true;
    if (y.getClass() != this.getClass()) return false;
    Board that = (Board) y; // java's requirement
    if (that.tiles.length != n) return false;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (that.tiles[i][j] != this.tiles[i][j]) return false;
      }
    }
    return true;
  }

  // a board that is obtained by exchanging any pair of tiles
  public Board twin() {
    Board twinBoard = new Board(tiles);
    int row = 0;
    int col = 0;
    if (tiles[row][col] == BLANK) // there is ONLY 0, just move to another one
      row++;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (tiles[i][j] != BLANK && tiles[i][j] != tiles[row][col]) {
          twinBoard.swap(row, col, i, j);
          return twinBoard;
        }
      }
    }
    return twinBoard;
  }

  // all neighboring boards
  public Iterable<Board> neighbors() {
    ArrayList<Board> neighbors = new ArrayList<>();
    int row = findBlank()[0];
    int col = findBlank()[1];
    if (row > 0) { // exch with above
      Board board = new Board(tiles);
      board.swap(row, col, row - 1, col);
      neighbors.add(board);
    }
    if (row < n - 1) { // exch with below
      Board board = new Board(tiles);
      board.swap(row, col, row + 1, col);
      neighbors.add(board);
    }
    if (col > 0) { // exch with left
      Board board = new Board(tiles);
      board.swap(row, col, row, col - 1);
      neighbors.add(board);
    }
    if (col < n - 1) { // exch with right
      Board board = new Board(tiles);
      board.swap(row, col, row, col + 1);
      neighbors.add(board);
    }
    return neighbors;
  }

  // copy origin to copy
  private void copyOf(int[][] origin, int[][] copy) {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        copy[i][j] = origin[i][j];
      }
    }
  }

  // swap i,j and x, y
  private void swap(int i, int j, int x, int y) {
    int temp = tiles[i][j];
    tiles[i][j] = tiles[x][y];
    tiles[x][y] = temp;
  }

  // find blank
  private int[] findBlank() {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (tiles[i][j] == BLANK) {
          int[] ans = new int[2];
          ans[0] = i;
          ans[1] = j;
          return ans;
        }
      }
    }
    throw new NoSuchElementException();
  }

  // unit testing (not graded)
  public static void main(String[] args) {
    int[][] blocks = new int[3][3];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        blocks[i][j] = i * 3 + j;
      }
    }
    Board board = new Board(blocks);
    StdOut.println(board.toString());
    StdOut.println("hamming:");
    StdOut.println(board.hamming());
    StdOut.println("manhattan:");
    StdOut.println(board.manhattan());
    StdOut.println("is goal:");
    StdOut.println(board.isGoal());
    StdOut.println("twin:");
    StdOut.println(board.twin());
    StdOut.println("equals:");
    StdOut.println(board.equals(board.twin()));
    StdOut.println("neighbors:");
    for (Board a : board.neighbors()) {
        StdOut.println(a.toString());
    }
  }
}
