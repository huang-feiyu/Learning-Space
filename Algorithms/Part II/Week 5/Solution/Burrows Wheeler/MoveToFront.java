import edu.princeton.cs.algs4.BinaryStdIn;
import edu.princeton.cs.algs4.BinaryStdOut;

import java.util.Objects;

public class MoveToFront {
  private static final int R = 256;

  // apply move-to-front encoding, reading from standard input and writing to standard output
  public static void encode() {
    char[] table = createChars();

    while (!BinaryStdIn.isEmpty()) {
      char ch = BinaryStdIn.readChar();
      int index = 0;
      for (int i = 0; i < R; i++)
        if (ch == table[i]) {
          index = i;
          break;
        }
      BinaryStdOut.write((char) index);
      // like bubble-sort
      for (int i = index; i > 0; i--) {
        char temp = table[i];
        table[i] = table[i - 1];
        table[i - 1] = temp;
      }
    }

    BinaryStdOut.close();
  }

  // apply move-to-front decoding, reading from standard input and writing to standard output
  public static void decode() {
    char[] table = createChars();

    while (!BinaryStdIn.isEmpty()) {
      char ch = BinaryStdIn.readChar();
      int index = (int) ch;
      BinaryStdOut.write(table[index]);

      for (int i = index; i > 0; i--) {
        char temp = table[i];
        table[i] = table[i - 1];
        table[i - 1] = temp;
      }
    }

    BinaryStdOut.close();
  }

  // initialize a word table
  private static char[] createChars() {
    char[] table = new char[R];
    for (int i = 0; i < R; i++) table[i] = (char) i; // initialize
    return table;
  }

  // if args[0] is "-", apply move-to-front encoding
  // if args[0] is "+", apply move-to-front decoding
  public static void main(String[] args) {
    if (Objects.equals(args[0], "-")) {
      encode();
    } else if (Objects.equals(args[0], "+"))
      decode();
  }

}
