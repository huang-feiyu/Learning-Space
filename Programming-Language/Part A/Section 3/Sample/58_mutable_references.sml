(* Programming Languages, Dan Grossman *)
(* Section 3: Mutable References *)

(* Mutable data structures are okay in some situations, in ML it is references *)

(* int ref *)
val x = ref 42 (* ref e to create a reference with initial contents `e` *)

val y = ref 42

val z = x

val _ = x := 43 (* := to update contents *)

val w = (!y) + (!z) (* 85 *) (* !e to retrieve contents *)

(* x + 1 does not type-check *)
