import edu.princeton.cs.algs4.StdOut;

import java.util.Arrays;

public class CircularSuffixArray {
  private final String string; // the String
  private final int len; // length of string
  private final int[] index;

  // represents a circular suffix implicitly
  private class CircularSuffix implements Comparable<CircularSuffix> {
    private final int firstIndex; // point to the first character

    public CircularSuffix(int firstIndex) {
      this.firstIndex = firstIndex;
    }

    public int compareTo(CircularSuffix that) {
      for (int i = 0; i < len; i++) {
        char thisChar = string.charAt(getIndex(i + this.getFirstIndex()));
        char thatChar = string.charAt(getIndex(i + that.getFirstIndex()));
        if (thisChar != thatChar) return thisChar > thatChar ? 1 : -1;
      }
      return 0;
    }

    // to avoid out of index
    private int getIndex(int i) {
      return i >= len ? i - len : i;
    }

    // get first
    public int getFirstIndex() {
      return firstIndex;
    }
  }

  // circular suffix array of s
  public CircularSuffixArray(String s) {
    if (s == null) throw new IllegalArgumentException();
    string = s;
    len = s.length();
    index = new int[len];
    CircularSuffix[] suffixes = new CircularSuffix[len];
    for (int i = 0; i < len; i++) suffixes[i] = new CircularSuffix(i);
    Arrays.sort(suffixes); // sort the suffixes
    for (int i = 0; i < len; i++) index[i] = suffixes[i].getFirstIndex();
  }

  // length of s
  public int length() {
    return len;
  }

  // returns index of ith sorted suffix
  public int index(int i) {
    if (i < 0 || i >= len) throw new IllegalArgumentException();
    return index[i];
  }

  // unit testing (required)
  public static void main(String[] args) {
    CircularSuffixArray suffixArray = new CircularSuffixArray("ABRACADABRA!");
    for (int i = 0; i < suffixArray.length(); i++) {
      StdOut.println(suffixArray.index(i));
    }
  }

}
