(* Programming Languages, Dan Grossman *)
(* Section 4: What is Type Inference *)

(* Type Inference:
    * type-checking(static): reject a program before it runs(compile-time)
        * Racket, Ruby, Python, Javascript
    * Dynamically typed languages: run-time
        * ML, Java, C#, Scala, C, C++
ML is implicitly typed: rarely need to write down types
*)

fun f x = (* infer val f : int -> int *)
    if x > 3
    then 42
    else x * 2
(*
fun g x = (* report type error *)
    if x > 3
    then true
    else x * 2
*)
