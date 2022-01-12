/*****************************************************************
 * Author: Huang
 * Date: 22.01.12
 * Website: https://huang-feiyu.github.io
 * Description: PercolationStats.java for algs4 homework-Percolation
 *****************************************************************/

import edu.princeton.cs.algs4.StdOut;
import edu.princeton.cs.algs4.StdRandom;
import edu.princeton.cs.algs4.StdStats;

public class PercolationStats {
  private static final double RATIO = 1.96;
  private final double[] results;
  private final double t;

  // perform independent trials on an n-by-n grid (uniform)
  public PercolationStats(int n, int trials) {
    if (n <= 0 || trials <= 0) {
      throw new IllegalArgumentException();
    }
    this.results = new double[trials];
    this.t = trials;
    double tempSquare = n * n;
    for (int i = 0; i < trials; i++) {
      Percolation percolation = new Percolation(n);
      while (!percolation.percolates()) {
        int row = StdRandom.uniform(1, n + 1);
        int col = StdRandom.uniform(1, n + 1);
        percolation.open(row, col);
      }
      results[i] = percolation.numberOfOpenSites() / tempSquare;
    }
  }

  // sample mean of percolation threshold
  public double mean() {
    return StdStats.mean(results);
  }

  // sample standard deviation of percolation threshold
  public double stddev() {
    return StdStats.stddev(results);
  }

  // low endpoint of 95% confidence interval
  public double confidenceLo() {
    return mean() - RATIO * stddev() / Math.sqrt(t);
  }

  // high endpoint of 95% confidence interval
  public double confidenceHi() {
    return mean() + RATIO * stddev() / Math.sqrt(t);
  }

  // test client (see below)
  public static void main(String[] args) {
    int len = Integer.parseInt(args[0]);
    int times = Integer.parseInt(args[1]);
    PercolationStats stats = new PercolationStats(len, times);
    String interval = "[" + stats.confidenceLo() + ", " + stats.confidenceHi() + "]";
    StdOut.println("mean                    = " + stats.mean());
    StdOut.println("stddev                  = " + stats.stddev());
    StdOut.println("95% confidence interval = " + interval);
  }

}
