/******************************************************************************
 * Author: Huang
 * Date: 22.01.25
 * Website: https://huang-feiyu.github.io
 * Description: SeamCarver.java for algs4 homework-SeamCarver
 ******************************************************************************/

import edu.princeton.cs.algs4.Picture;
import java.awt.Color;

public class SeamCarver {
  private Picture picture; // current picture
  private int height;
  private int width;

  // create a seam carver object based on the given picture
  public SeamCarver(Picture picture) {
    if (picture == null) throw new IllegalArgumentException();
    this.picture = new Picture(picture);
    this.height = picture.height();
    this.width = picture.width();
  }

  // current picture
  public Picture picture() {
    return new Picture(picture);
  }

  // width of current picture
  public int width() {
    return width;
  }

  // height of current picture
  public int height() {
    return height;
  }

  // energy of pixel at column x and row y
  public double energy(int x, int y) {
    validatePixelPos(x, y);
    if (x == width - 1 || y == height - 1 || x == 0 || y == 0)
      return 1000.0; // edge pixel
    Color left = picture.get(x - 1, y);
    Color right = picture.get(x + 1, y);
    Color top = picture.get(x, y - 1);
    Color bottom = picture.get(x, y + 1);
    int colorSquare = getSquareDelta(left, right) + getSquareDelta(top, bottom);
    return Math.sqrt(colorSquare);
  }

  // sequence of indices for horizontal seam
  public int[] findHorizontalSeam() {
    transpose();
    int[] res = findVerticalSeam();
    transpose();
    return res;
  }

  // transpose picture
  private void transpose() {
    Picture transpose = new Picture(height, width);
    for (int i = 0; i < height; i++)
      for (int j = 0; j < width; j++)
        transpose.setRGB(i, j, picture.getRGB(j, i));
    picture = transpose;
    height = transpose.height();
    width = transpose.width();
  }

  // sequence of indices for vertical seam
  public int[] findVerticalSeam() {
    int[][] edgeTo = new int[width][height];
    double[][] distTo = new double[width][height];
    double[][] energy = new double[width][height];
    // initialize
    for (int i = 0; i < width; i++)
      for (int j = 0; j < height; j++) {
        energy[i][j] = energy(i, j);
        distTo[i][j] = j == 0 ? energy[i][j] : Double.POSITIVE_INFINITY;
      }

    // dynamic programming: from top to bottom
    for (int j = 1; j < height; j++)
      for (int i = 0; i < width; i++) edgeTo[i][j] = distDP(distTo, edgeTo, energy, i, j);

    int[] res = new int[height];
    res[height - 1] = findLowestBottom(distTo);
    for (int i = height - 2; i > -1; i--) {
      res[i] = edgeTo[res[i + 1]][i + 1]; // backtracking
    }
    return res;
  }

  // dynamic programming
  private int distDP(double[][] distTo, int[][] edgeTo, double[][] energy, int i, int j) {
    validatePixelPos(i, j);
    double minDis = distTo[i][j];
    int pre = edgeTo[i][j];
    if (distTo[i][j - 1] + energy[i][j] < minDis) {
      minDis = distTo[i][j - 1] + energy[i][j]; // top
      pre = i;
    }
    if (i > 0 && distTo[i - 1][j - 1] + energy[i][j] <= minDis) {
      minDis = distTo[i - 1][j - 1] + energy[i][j]; // left top
      pre = i - 1;
    }
    if (i < width - 1 && distTo[i + 1][j - 1] + energy[i][j] < minDis) {
      minDis = distTo[i + 1][j - 1] + energy[i][j]; // right top
      pre = i + 1;
    }
    distTo[i][j] = minDis;
    return pre;
  }

  // find the lowest one in distTo[*][height - 1]
  private int findLowestBottom(double[][] distTo) {
    double min = Double.POSITIVE_INFINITY;
    int pos = 0;
    for (int i = 0; i < width; i++)
      if (min > distTo[i][height - 1]) {
        min = distTo[i][height - 1];
        pos = i;
      }
    return pos;
  }

  // remove horizontal seam from current picture
  public void removeHorizontalSeam(int[] seam) {
    transpose();
    removeVerticalSeam(seam);
    transpose();
  }

  // remove vertical seam from current picture
  public void removeVerticalSeam(int[] seam) {
    validateSeam(seam);
    Picture newPicture = new Picture(width - 1, height);
    for (int j = 0; j < height; j++) {
      for (int i = 0; i < width - 1; i++) {
        if (i < seam[j])
          newPicture.setRGB(i, j, picture.getRGB(i, j));
        else if (i >= seam[j])
          newPicture.setRGB(i, j, picture.getRGB(i + 1, j));
      }
    }
    picture = newPicture;
    width -= 1;
  }

  // validate seam
  private void validateSeam(int[] seam) {
    if (seam == null || seam.length != height)
      throw new IllegalArgumentException();
    for (int i = 0; i < seam.length; i++) {
      if (seam[i] < 0 || seam[i] >= width) throw new IllegalArgumentException();
      if (i > 0 && Math.abs(seam[i] - seam[i - 1]) > 1)
        throw new IllegalArgumentException();
    }
  }

  // validate x,y
  private void validatePixelPos(int x, int y) {
    if (x >= width || y >= height || x < 0 || y < 0)
      throw new IllegalArgumentException();
  }

  // calculate one Δ^2
  private int getSquareDelta(Color colA, Color colB) {
    int red = colA.getRed() - colB.getRed();
    int blue = colA.getBlue() - colB.getBlue();
    int green = colA.getGreen() - colB.getGreen();
    return red * red + blue * blue + green * green;
  }

}
