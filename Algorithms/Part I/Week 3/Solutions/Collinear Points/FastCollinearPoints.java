/*****************************************************************
 * Author: Huang
 * Date: 22.01.14
 * Website: https://huang-feiyu.github.io
 * Description: FastCollinearPoints.java for algs4 homework-CollinearPoints
 *****************************************************************/

import edu.princeton.cs.algs4.In;
import edu.princeton.cs.algs4.StdDraw;
import edu.princeton.cs.algs4.StdOut;

import java.util.ArrayList;
import java.util.Arrays;

public class FastCollinearPoints {
  private final ArrayList<LineSegment> segmentList = new ArrayList<>();

  // finds all line segments containing 4 or more points
  public FastCollinearPoints(Point[] points) {
    if (points == null) throw new IllegalArgumentException();
    for (Point point : points) {
      if (point == null) throw new IllegalArgumentException();
    }
    Point[] copy = Arrays.copyOf(points, points.length);
    Arrays.sort(copy);
    for (int i = 0; i < copy.length - 1; i++) {
      if (copy[i].compareTo(copy[i + 1]) == 0) throw new IllegalArgumentException();
    }
    // think of p as the origin
    for (Point p : points) {
      Point[] others = new Point[points.length - 1];
      for (int i = 0, j = 0; i < points.length; j++, i++) {
        if (points[i] == p) {
          j--;
          continue;
        }
        others[j] = points[i];
      }
      // sort according to the slope it makes with p
      Arrays.sort(others, p.slopeOrder());
      int count = 0;
      // In p-q-r-s, we need ONLY p-s
      Point min = null; // min is p
      Point max = null; // max is s
      for (int j = 0; j < others.length - 1; j++) {
        if (Double.compare(p.slopeTo(others[j]), p.slopeTo(others[j + 1])) == 0) {
          count++; // count++ if slopes equal
          if (min == null && max == null) {
            if (p.compareTo(others[j]) > 0) {
              max = p;
              min = others[j];
            } else {
              max = others[j];
              min = p;
            }
          }
          if (others[j + 1].compareTo(min) < 0) {
            min = others[j + 1];
          }
          if (others[j + 1].compareTo(max) > 0) {
            max = others[j + 1];
          }
          if (j == others.length - 2 && count >= 2 && p.compareTo(min) == 0) {
            segmentList.add(new LineSegment(min, max));
          }
        } else {
          if (count >= 2 && p.compareTo(min) == 0) {
            segmentList.add(new LineSegment(min, max));
          }
          count = 0;
          max = null;
          min = null;
        }
      }
    }
  }

  // the number of line segments
  public int numberOfSegments() {
    return segmentList.size();
  }

  // the line segments
  public LineSegment[] segments() {
    return segmentList.toArray(new LineSegment[0]);
  }

  // test client
  public static void main(String[] args) {

    // read the n points from a file
    In in = new In(args[0]);
    int n = in.readInt();
    Point[] points = new Point[n];
    for (int i = 0; i < n; i++) {
      int x = in.readInt();
      int y = in.readInt();
      points[i] = new Point(x, y);
    }

    // draw the points
    StdDraw.enableDoubleBuffering();
    StdDraw.setXscale(0, 32768);
    StdDraw.setYscale(0, 32768);
    for (Point p : points) {
      p.draw();
    }
    StdDraw.show();

    // print and draw the line segments
    FastCollinearPoints collinear = new FastCollinearPoints(points);
    for (LineSegment segment : collinear.segments()) {
      StdOut.println(segment);
      segment.draw();
    }
    StdDraw.show();
  }
}
