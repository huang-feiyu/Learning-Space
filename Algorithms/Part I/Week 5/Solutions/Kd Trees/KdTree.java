/******************************************************************************
 * Author: Huang
 * Date: 22.01.19
 * Website: https://huang-feiyu.github.io
 * Description: KdTree.java for algs4 homework-KdTree
 ******************************************************************************/

import edu.princeton.cs.algs4.Point2D;
import edu.princeton.cs.algs4.Queue;
import edu.princeton.cs.algs4.RectHV;
import edu.princeton.cs.algs4.StdDraw;
import edu.princeton.cs.algs4.StdOut;

public class KdTree {
  private Node root;
  private int sz;

  private static class Node {
    private RectHV rect; // the axis-aligned rectangle corresponding to this node
    private Node lb; // the left/bottom subtree
    private Node rt; // the right/top subtree
    private boolean isVertical; // is the node vertical
    private final Point2D point; // the point

    public Node(Point2D p) {
      this.point = p;
    }
  }

  // construct an empty set of points
  public KdTree() {
    root = null;
    sz = 0;
  }

  // is the set empty?
  public boolean isEmpty() {
    return sz == 0;
  }

  // number of points in the set
  public int size() {
    return sz;
  }

  // add the point to the set (if it is not already in the set)
  public void insert(Point2D p) {
    if (p == null) throw new IllegalArgumentException();
    if (contains(p)) return;
    root = insertRec(root, p, new RectHV(0, 0, 1, 1), 1);
  }

  // insert sub-method: to change the child
  private Node insertRec(Node n, Point2D p, RectHV rect, int count) {
    if (n == null) {
      Node node = new Node(p);
      node.isVertical = count % 2 != 0;
      node.rect = rect;
      this.sz++;
      return node;
    }
    // lb or rt
    boolean cmp = n.isVertical ? p.x() < n.point.x() : p.y() < n.point.y();
    RectHV pRect; // p's rect
    if (cmp) {
      // n is parent, left leave
      if (n.lb == null) {
        double x0 = rect.xmin();
        double y0 = rect.ymin();
        double x1, y1;
        if (n.isVertical) {
          x1 = n.point.x();
          y1 = rect.ymax();
        } else {
          x1 = rect.xmax();
          y1 = n.point.y();
        }
        pRect = new RectHV(x0, y0, x1, y1); // next time, it will insert
      } else {
        pRect = n.lb.rect;
      }
      n.lb = insertRec(n.lb, p, pRect, count + 1);
    } else {
      // n is parent, left leave
      if (n.rt == null) {
        double x1 = rect.xmax();
        double y1 = rect.ymax();
        double x0, y0;
        if (n.isVertical) {
          x0 = n.point.x();
          y0 = rect.ymin();
        } else {
          x0 = rect.xmin();
          y0 = n.point.y();
        }
        pRect = new RectHV(x0, y0, x1, y1); // next time, it will insert
      } else {
        pRect = n.rt.rect;
      }
      n.rt = insertRec(n.rt, p, pRect, count + 1);
    }
    return n;
  }

  // does the set contain point p?
  public boolean contains(Point2D p) {
    if (p == null) throw new IllegalArgumentException();
    if (isEmpty()) return false;

    Node node = root;
    while (node != null) {
      if (node.isVertical) {
        // compare horizontal
        if (node.point.x() > p.x()) {
          node = node.lb;
        } else if (node.point.x() < p.x()) {
          node = node.rt;
        } else {
          if (node.point.y() == p.y()) {
            return true;
          } else {
            node = node.rt;
          }
        }
      } else {
        // compare vertical
        if (node.point.y() > p.y()) {
          node = node.lb;
        } else if (node.point.y() < p.y()) {
          node = node.rt;
        } else {
          if (node.point.x() == p.x()) {
            return true;
          } else {
            node = node.rt;
          }
        }
      }
    }
    return false;
  }

  // draw all points to standard draw
  public void draw() {
    if (isEmpty()) return;
    drawRec(root);
  }

  // draw recursively
  private void drawRec(Node n) {
    if (n == null) throw new IllegalArgumentException();
    drawPoint(n.point);
    if (n.isVertical) {
      drawRedLine(n.rect.ymin(), n.rect.ymax(), n.point.x());
    } else {
      drawBlueLine(n.rect.xmin(), n.rect.xmax(), n.point.y());
    }
    if (n.lb != null) drawRec(n.lb);
    if (n.rt != null) drawRec(n.rt);
  }

  // all points that are inside the rectangle (or on the boundary)
  public Iterable<Point2D> range(RectHV rect) {
    if (rect == null) throw new IllegalArgumentException();

    Queue<Point2D> queue = new Queue<>();
    rangeRec(root, rect, queue);
    return queue;
  }

  // get range recursively
  private void rangeRec(Node n, RectHV rect, Queue<Point2D> queue) {
    if (n == null) return;
    if (n.rect.intersects(rect)) {
      if (rect.contains(n.point)) queue.enqueue(n.point);
      rangeRec(n.lb, rect, queue);
      rangeRec(n.rt, rect, queue);
    }
  }

  // a nearest neighbor in the set to point p; null if the set is empty
  public Point2D nearest(Point2D point) {
    if (point == null) throw new IllegalArgumentException();
    if (isEmpty()) return null;

    return nearestRec(root, point, root.point);
  }

  // get the nearest point recursively
  private Point2D nearestRec(Node n, Point2D point, Point2D c) {
    Point2D closest = c;
    if (n == null) return closest;
    if (squareDis(point, closest) > squareDis(point, n.point)) closest = n.point;
    // if ANY point inside rect can get closer distance to point
    if (n.rect.distanceSquaredTo(point) < squareDis(point, closest)) {
      Node near;
      Node far;
      // which subtree is closer to the point
      if ((n.isVertical && point.x() < n.point.x())
          || (!n.isVertical && point.y() < n.point.y())) {
        near = n.lb;
        far = n.rt;
      } else {
        near = n.rt;
        far = n.lb;
      }
      closest = nearestRec(near, point, closest);
      closest = nearestRec(far, point, closest);
    }
    return closest;
  }

  // draw Point
  private void drawPoint(Point2D p) {
    StdDraw.setPenColor(StdDraw.BLACK);
    StdDraw.setPenRadius(0.01);
    StdDraw.point(p.x(), p.y());
  }

  // draw blue Line, horizontal
  private void drawBlueLine(double x0, double x1, double y) {
    StdDraw.setPenColor(StdDraw.BLUE);
    StdDraw.setPenRadius();
    StdDraw.line(x0, y, x1, y);
  }

  // draw red Line, vertical
  private void drawRedLine(double y0, double y1, double x) {
    StdDraw.setPenColor(StdDraw.RED);
    StdDraw.setPenRadius();
    StdDraw.line(x, y0, x, y1);
  }

  // use square distance instead of sqrt
  private double squareDis(Point2D p, Point2D q) {
    double xSquare = ((p.x() - q.x()) * (p.x() - q.x()));
    double ySquare = ((p.y() - q.y()) * (p.y() - q.y()));
    return xSquare + ySquare;
  }

  // unit testing of the methods (optional)
  public static void main(String[] args) {
    KdTree tree = new KdTree();
    tree.insert(new Point2D(0.2, 0.2));
    tree.insert(new Point2D(0.3, 0.3));
    tree.insert(new Point2D(0.4, 0.3));
    tree.insert(new Point2D(0.5, 0.8));
    tree.insert(new Point2D(0.3, 0.0));
    tree.insert(new Point2D(0.8, 0.3));
    tree.insert(new Point2D(0.0, 0.2));
    StdOut.println(tree.size());
    StdOut.println(tree.contains(new Point2D(0.2, 0.3)));
    StdOut.println(tree.contains(new Point2D(0.2, 0.2)));
    tree.draw();
  }
}
