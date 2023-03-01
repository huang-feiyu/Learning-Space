(* Programming Languages, Dan Grossman *)
(* Section 2: Case Expressions *)

datatype mytype = TwoInts of int * int
                | Str of string
                | Pizza

fun f x =
    case x of
    Pizza => 3
      | Str s => 8
      | TwoInts(i1,i2) => i1 + i2

(*    | Pizza => 4; (* redundant case: error *) *)
(* fun g x = case x of Pizza => 3 (* missing cases: warning *) *)

val temp = f (TwoInts(1, 2))

(* Patterns: each pattern is a constructor name followed by
             the right number variables
    * patterns are not expressions:
      we do not evaluate them, we see if the result of e0 matches them
 *)
