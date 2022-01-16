/*****************************************************************
 * Author: Huang
 * Date: 22.01.14
 * Website: https://huang-feiyu.github.io
 * Description: Point.java for algs4 homework-CollinearPoints
 *****************************************************************/

import java.util.Arrays;
import java.util.Comparator;
import edu.princeton.cs.algs4.StdDraw;

public class Point implements Comparable<Point> {

  private final int x;     // x-coordinate of this point
  private final int y;     // y-coordinate of this point

  // Initialize a new point
  public Point(int x, int y) {
    /* DO NOT MODIFY */
    this.x = x;
    this.y = y;
  }

  // Draws this point to standard draw.
  public void draw() {
    StdDraw.point(x, y);
  }

  // Draws the line segment between this point and that point
  public void drawTo(Point that) {
    StdDraw.line(this.x, this.y, that.x, that.y);
  }

  // Returns the slope between two points
  public double slopeTo(Point that) {
    if (compareTo(that) == 0) {
      return Double.NEGATIVE_INFINITY; // -∞ if this is exactly that
    }
    if (this.x == that.x) {
      return Double.POSITIVE_INFINITY; // +∞ if vertical
    }
    if (this.y == that.y) {
      return 0.0; // +0.0 if horizontal
    }
    return (that.y - this.y) * 1.0 / (that.x - this.x); // slope
  }

  // Compares two points (polar angle)
  public int compareTo(Point that) {
    if (this.y < that.y) return -1;
    else if (this.y == that.y && this.x < that.x) return -1;
    else if (this.y == that.y && this.x == that.x) return 0;
    return 1;
  }

  // Compares two points by the slope they make with this point.
  public Comparator<Point> slopeOrder() {
    return new SlopeOrder();
  }

  // a class implements Comparator
  private class SlopeOrder implements Comparator<Point> {
    @Override
    public int compare(Point a, Point b) {
      Point temp = new Point(x, y);
      double slopeA = temp.slopeTo(a);
      double slopeB = temp.slopeTo(b);
      return Double.compare(slopeA, slopeB);
    }
  }

  // toString() for debugging
  public String toString() {
    return "(" + x + ", " + y + ")";
  }

  // test client
  public static void main(String[] args) {
    Point[] points = new Point[9];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        points[i * 3 + j] = new Point(i, j);
      }
    }
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        points[i * 3 + j].draw();
      }
    }
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        points[0].drawTo(points[i * 3 + j]);
      }
    }
    Arrays.sort(points);
  }
}
