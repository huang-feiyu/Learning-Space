/******************************************************************************
 * Author: Huang
 * Date: 22.01.19
 * Website: https://huang-feiyu.github.io
 * Description: PointSET.java for algs4 homework-KdTree
 ******************************************************************************/

import edu.princeton.cs.algs4.Point2D;
import edu.princeton.cs.algs4.Queue;
import edu.princeton.cs.algs4.RectHV;
import edu.princeton.cs.algs4.SET;
import edu.princeton.cs.algs4.StdOut;

public class PointSET {
  private final SET<Point2D> tree;

  // construct an empty set of points
  public PointSET() {
    tree = new SET<>();
  }

  // is the set empty?
  public boolean isEmpty() {
    return tree.isEmpty();
  }

  // number of points in the set
  public int size() {
    return tree.size();
  }

  // add the point to the set (if it is not already in the set)
  public void insert(Point2D p) {
    tree.add(p);
  }

  // does the set contain point p?
  public boolean contains(Point2D p) {
    return tree.contains(p);
  }

  // draw all points to standard draw
  public void draw() {
    for (Point2D p : tree) {
      p.draw();
    }
  }

  // all points that are inside the rectangle (or on the boundary)
  public Iterable<Point2D> range(RectHV rect) {
    if (rect == null) throw new IllegalArgumentException();

    Queue<Point2D> queue = new Queue<>();
    for (Point2D p : tree)
      if (rect.contains(p))
        queue.enqueue(p);

    return queue;
  }

  // a nearest neighbor in the set to point p; null if the set is empty
  public Point2D nearest(Point2D point) {
    if (point == null) throw new IllegalArgumentException();
    if (isEmpty()) return null;

    double min = Double.POSITIVE_INFINITY;
    Point2D current = new Point2D(0, 0);
    for (Point2D p : tree) {
      double squareDis = squareDis(p, point);
      if (squareDis < min) {
        min = squareDis;
        current = p;
      }
    }
    return current;
  }

  // use square distance instead of sqrt
  private double squareDis(Point2D p, Point2D q) {
    double xSquare = ((p.x() - q.x()) * (p.x() - q.x()));
    double ySquare = ((p.y() - q.y()) * (p.y() - q.y()));
    return xSquare + ySquare;
  }

  // unit testing of the methods (optional)
  public static void main(String[] args) {
    int a = 0;
    StdOut.println(a);
  }
}
