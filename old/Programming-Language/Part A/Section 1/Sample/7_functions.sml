(* Programming Languages, Dan Grossman *)
(* Section 1: simple functions *)

(* this function correct only for y >= 0 *)
fun pow (x : int, y : int) = 
    if y = 0
    then 1
    else x * pow(x, y - 1) (* recursion, infinite loop if y < 0 *)

fun cube (x : int) =
    pow(x, 3)

(* Unless a function has exactly one argument,
   you need to use parentheses to call it *)
val sixtyfour = cube(4)
(* val sixtyfour = cube 4 *)

val fortytwo = pow(2, 2 + 2) + pow(4, 2) + cube(2) + 2

(* Syntax: fun x0 (x1 : ti, ..., xn : tn) = e *)
(* Evaluation: A function is a value *)
(* Type-checking: Adds binding x0 : (ti * ... * tn) -> t *)
(* Function calls: x0 (e1, ..., en) *)