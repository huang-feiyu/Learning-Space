(* Programming Languages, Dan Grossman *)
(* Section 3: Introduction to First-Class Functions *)

(* Functional Programming:
    * Avoid mutation in most/all cases
    * Using functions as values
 * Functional Language: The language where functional programming is the easy,
   natural, conventional way to do it, all the libaries written in that.
 * First-class functions: can use them wherever we use values(Functions are values, too)
 * Function Closures: Functions can use bindings from outside the function
   definition(in scope where function is defined)
 *)

fun double x = 2 * x
fun incr x = x + 1
val a_tuple = (double, incr, double(incr 7))
val eighteen = (#1 a_tuple) 9
