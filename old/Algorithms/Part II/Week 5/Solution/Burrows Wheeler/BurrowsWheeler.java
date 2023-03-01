import edu.princeton.cs.algs4.BinaryStdIn;
import edu.princeton.cs.algs4.BinaryStdOut;

import java.util.Objects;

public class BurrowsWheeler {
  private static final int R = 256;

  // apply Burrows-Wheeler transform,
  // reading from standard input and writing to standard output
  public static void transform() {
    String string = BinaryStdIn.readString();
    CircularSuffixArray suffixArray = new CircularSuffixArray(string);
    int len = string.length();
    int first = 0;
    for (int i = 0; i < len; i++)
      if (suffixArray.index(i) == 0) {
        first = i;
        break;
      }
    BinaryStdOut.write(first);

    // the ending character set
    char[] t = new char[len];
    for (int i = 0; i < len; i++) {
      // get the end character of each suffix
      if (i == first)
        t[i] = string.charAt(len - 1);
      else
        t[i] = string.charAt(suffixArray.index(i) - 1);
    }

    for (int i = 0; i < len; i++)
      BinaryStdOut.write(t[i]);
    BinaryStdOut.close();
  }

  // apply Burrows-Wheeler inverse transform,
  // reading from standard input and writing to standard output
  public static void inverseTransform() {
    int first = BinaryStdIn.readInt();
    String s = BinaryStdIn.readString();
    int len = s.length();

    int[] count = new int[R + 1];
    int[] next = new int[len];

    for (int i = 0; i < len; i++) count[s.charAt(i) + 1]++;
    for (int i = 1; i < R + 1; i++) count[i] += count[i - 1];
    for (int i = 0; i < len; i++) next[count[s.charAt(i)]++] = i;
    int i = next[first];
    for (int j = 0; j < len; j++) {
      BinaryStdOut.write(s.charAt(i));
      i = next[i];
    }
    BinaryStdOut.close();
  }

  // if args[0] is "-", apply Burrows-Wheeler transform
  // if args[0] is "+", apply Burrows-Wheeler inverse transform
  public static void main(String[] args) {
    if (Objects.equals(args[0], "-")) {
      transform();
    } else if (Objects.equals(args[0], "+"))
      inverseTransform();
  }

}
