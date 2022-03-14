(* Programming Languages, Dan Grossman *)
(* Section 1: Some Errors *)

(* This program has several errors in it so we can try to debug them. *)

val x = 34 (* semicolon is not necessay in files, but in REPL *)

val y = x + 1

val z = if y > 0 then false else x < 4

val q = if y > 0 then 0 else 42

val a = ~5 (* ~ is the `minus` character for single number *)

val w = 0

val funny = 34

val v = x div (w + 1) (* div for `/` *)

val fourteen = 7 + 7

