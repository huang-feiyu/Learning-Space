(* Programming Languages, Dan Grossman *)
(* Section 3: Lexical Scope *)

(* 1 *) val x = 1

(* 2 *) fun f y = x + y (* evaluates x+y in current environment *)

(* 3 *) val x = 2

(* 4 *) val y = 3

(* 5 *) val z = f (x + y)

(* Closures:
  * A function value has two parts
    * The code
    * The environment that was current when the function was defined
*)