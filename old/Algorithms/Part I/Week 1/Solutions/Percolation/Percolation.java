/*****************************************************************
 * Author: Huang
 * Date: 22.01.12
 * Website: https://huang-feiyu.github.io
 * Description: Percolation.java for algs4 homework-Percolation
 *****************************************************************/

import edu.princeton.cs.algs4.StdOut;
import edu.princeton.cs.algs4.WeightedQuickUnionUF;

public class Percolation {
  private boolean[][] grid; // grid[i][j] == false for blocked, true for open
  private final WeightedQuickUnionUF uf; // UF with top and bottom
  private final WeightedQuickUnionUF backuf; // UF with ONLY top
  private final int sz; // the size of 1D UF
  private final int n;
  private int openNum;

  // creates n-by-n grid, with all sites initially blocked.
  public Percolation(int n) {
    if (n <= 0) {
      throw new IllegalArgumentException();
    }
    this.grid = new boolean[n][n];
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        // all sites initially blocked
        grid[i][j] = false;
      }
    }
    this.n = n;
    this.openNum = 0;
    this.sz = this.n * this.n + 2; // two virtual node
    this.uf = new WeightedQuickUnionUF(sz);
    this.backuf = new WeightedQuickUnionUF(sz - 1);
    // connect virtual node with top/bottom row
    for (int i = 1; i <= this.n; i++) {
      uf.union(0, i);
      uf.union(sz - 1, this.n * this.n + 1 - i);
      backuf.union(0, i);
    }
  }

  // opens the site (row, col) if it is not open already
  public void open(int row, int col) {
    validArgs(row, col);
    if (!isOpen(row, col)) {
      openNum++;
    }
    grid[row - 1][col - 1] = true;
    int center = posToIndex(row, col);
    // connect node nearby
    if (row < n && isOpen(row + 1, col)) {
      uf.union(posToIndex(row + 1, col), center);
      backuf.union(posToIndex(row + 1, col), center);
    }
    if (row > 1 && isOpen(row - 1, col)) {
      uf.union(posToIndex(row - 1, col), center);
      backuf.union(posToIndex(row - 1, col), center);
    }
    if (col > 1 && isOpen(row, col - 1)) {
      uf.union(posToIndex(row, col - 1), center);
      backuf.union(posToIndex(row, col - 1), center);
    }
    if (col < n && isOpen(row, col + 1)) {
      uf.union(posToIndex(row, col + 1), center);
      backuf.union(posToIndex(row, col + 1), center);
    }
  }

  // is the site (row, col) open?
  public boolean isOpen(int row, int col) {
    validArgs(row, col);
    return grid[row - 1][col - 1];
  }

  // is the site (row, col) full?
  public boolean isFull(int row, int col) {
    validArgs(row, col);
    if (row == 1) {
      return isOpen(row, col);
    }
    return isOpen(row, col) && backuf.find(posToIndex(row, col)) == uf.find(0);
  }

  // returns the number of open sites
  public int numberOfOpenSites() {
    return openNum;
  }

  // does the system percolate?
  public boolean percolates() {
    return n == 1 ? isOpen(1, 1) : uf.find(0) == uf.find(sz - 1);
  }

  // make the 2D grid to 1D UF
  private int posToIndex(int row, int col) {
    return (row - 1) * n + col;
  }

  // check if n is valid
  private void validArgs(int row, int col) {
    if (row < 1 || row > n || col < 1 || col > n) {
      throw new IllegalArgumentException();
    }
  }

  // test client (optional)
  public static void main(String[] args) {
    Percolation percolation = new Percolation(3);
    percolation.open(1, 1);
    percolation.open(2, 2);
    StdOut.println(percolation.isFull(2, 2));
    percolation.open(3, 3);
    StdOut.println(percolation.percolates());
    percolation.open(1, 2);
    StdOut.println(percolation.isOpen(1, 2));
    StdOut.println(percolation.isFull(2, 2));
    percolation.open(3, 2);
    StdOut.println(percolation.percolates());
  }
}
