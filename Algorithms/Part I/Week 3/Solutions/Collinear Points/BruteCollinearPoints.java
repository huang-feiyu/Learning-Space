/*****************************************************************
 * Author: Huang
 * Date: 22.01.14
 * Website: https://huang-feiyu.github.io
 * Description: BruteCollinearPoints.java for algs4 homework-Queue
 *****************************************************************/

import edu.princeton.cs.algs4.In;
import edu.princeton.cs.algs4.StdDraw;
import edu.princeton.cs.algs4.StdOut;

import java.util.ArrayList;
import java.util.Arrays;

public class BruteCollinearPoints {
  private final ArrayList<LineSegment> segmentList = new ArrayList<>();

  // finds all line segments containing 4 points
  public BruteCollinearPoints(Point[] points) {
    if (points == null) throw new IllegalArgumentException();
    for (Point point : points) {
      if (point == null) throw new IllegalArgumentException();
    }
    Point[] copy = Arrays.copyOf(points, points.length);
    Arrays.sort(copy);
    for (int i = 0; i < copy.length - 1; i++) {
      if (copy[i].compareTo(copy[i + 1]) == 0) throw new IllegalArgumentException();
    }
    for (int i = 0; i < copy.length - 3; i++) {
      for (int j = i + 1; j < copy.length - 2; j++) {
        for (int k = j + 1; k < copy.length - 1; k++) {
          // when three points are not collinear, then next loop
          if (copy[i].slopeTo(copy[j]) == copy[j].slopeTo(copy[k]))
            for (int l = k + 1; l < copy.length; l++) {
              if (copy[j].slopeTo(copy[k]) == copy[k].slopeTo(copy[l])) {
                segmentList.add(new LineSegment(copy[i], copy[l]));
              }
            }
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
    BruteCollinearPoints collinear = new BruteCollinearPoints(points);
    for (LineSegment segment : collinear.segments()) {
      StdOut.println(segment);
      segment.draw();
    }
    StdDraw.show();
  }
}
