(* Programming Languages, Dan Grossman *)
(* Section 1: Examples to Demonstrate Shadowing *)

val a = 10

val b = a * 2 (* b->20 *)

val a = 5 (* a->5 *)

val c = b (* c->20 *)

val d = a

val a = a + 1

(* next line does not type-check, f not in environment *)
(* val g = f - 3  *)

val f = a * 2


val x = 12
val n = 2+x (*14*)
val x = n-14 (*0*)
val n = n*x (*0*)
val b = if n = x then 8 else 5 (*8*)
val a = if b = 5 then x else b (*8*)