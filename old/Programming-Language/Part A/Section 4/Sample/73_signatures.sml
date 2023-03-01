(* Programming Languages, Dan Grossman *)
(* Section 4: Signatures and Hiding Things *)

(* signature is a type for a module:
  what bindings does it have and what are their types
    * like a header file in C/C++
    * Syntax:
    signature
    sig
    myBindings
    end
    * real value: Hide implementation details
      it's convenient to have "private" top-level functions
*)

signature MATHLIB =
sig
val fact : int -> int
val half_pi : real
(* val doubler : int -> int *) (* can hide bindings from clients *)
end

(* `:>` provide a signature for a Module *)
structure MyMathLib :> MATHLIB =
struct
fun fact x =
  if x=0
  then 1
  else x * fact (x - 1)

val half_pi = Math.pi / 2.0

fun doubler y = y + y (* this one cannot be used outside the module *)
end

val pi = MyMathLib.half_pi + MyMathLib.half_pi

val twenty_eight = MyMathLib.doubler 14
