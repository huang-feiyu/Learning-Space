(* Programming Languages, Dan Grossman *)
(* Section 2: Datatype Bindings *)

(* one of type:
 * TwoInts: int * int -> mytype
 * Str: string -> mytype
 * Pizza: mytype
 *)
datatype mytype = TwoInts of int * int
                | Str of string
                | Pizza

val a = Str "hi" (* mytype *)
val b = Str (* fn : string -> mytype *)
val c = Pizza (* mytype *)
val d = TwoInts(1+2,3+4) (* mytype *)
val e = a

(* Access:
 * 1. Check what variant it is `isStr`
 * 2. Extract the data `getStrData`
 * one-of types used function: `null` `isSome` `hd` `tl` `valOf`
 *)

(* Do _not_ redo datatype bindings (e.g., via use "filename.sml".
   Doing so will shadow the type name and the constructors.)
datatype mytype = TwoInts of int * int | Str of string | Pizza *)