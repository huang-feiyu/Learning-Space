(* hw3.sml
 * Description: Coursera Programming Languages, Homework 3
 * Author: Huang
 * Date: 3.28
**)

exception NoAnswer

datatype pattern = Wildcard
        | Variable of string
        | UnitP
        | ConstP of int
        | TupleP of pattern list
        | ConstructorP of string * pattern

datatype valu = Const of int
        | Unit
        | Tuple of valu list
        | Constructor of string * valu

(* fn : (unit -> int) -> (string -> int) -> pattern -> int *)
fun g f1 f2 p =
  let
    val r = g f1 f2
  in
    case p of
      Wildcard          => f1 ()
    | Variable x        => f2 x
    | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
    | ConstructorP(_,p) => r p
    | _                 => 0
  end

(* 1 *)
(* fn : string list -> string list *)
fun only_capitals strs =
  List.filter (fn str => Char.isUpper(String.sub(str, 0))) strs

(* 2 *)
(* fn : string list -> string *)
fun longest_string1 strs =
  foldl (fn (x, y) => if String.size(x) > String.size(y) then x else y) "" strs

(* 3 *)
(* fn : string list -> string *)
fun longest_string2 strs =
  foldl (fn (x, y) => if String.size(x) >= String.size(y) then x else y) "" strs

(* 4 *)
(* fn : (int * int -> bool) -> string list -> string *)
fun longest_string_helper f =
  foldl (fn (x, y) => if f(String.size x, String.size y) then x else y) ""

val longest_string3 =
  longest_string_helper (fn (x, y) => x > y)

val longest_string4 =
  longest_string_helper (fn (x, y) => x >= y)

(* 5 *)
(* fn : string list -> string *)
val longest_capitalized = longest_string1 o only_capitals

(* 6 *)
(* fn : string -> string *)
val rev_string = String.implode o rev o String.explode

(* 7 *)
(* fn : ('a -> 'b option) -> 'a list -> 'b *)
fun first_answer f xs =
  case xs of
    [] => raise NoAnswer
  | x::xs' => case f x of
                NONE => first_answer f xs'
              | SOME y => y

(* 8 *)
(* fn : (’a -> ’b list option) -> ’a list -> ’b list option *)
fun all_answers f xs =
  let
    fun aux(xs, acc) =
      case xs of
        [] => SOME acc
      | x::xs' => case f x of
                    NONE => NONE
                  | SOME y => aux(xs', acc @ y)
  in
    aux(xs, [])
  end

(* 9-a *)
(* fn : pattern -> int *)
val count_wildcards =
  g (fn () => 1) (fn _ => 0)

(* 9-b *)
(* fn : pattern -> int *)
val count_wild_and_variable_lengths =
  g (fn () => 1) String.size

(* 9-c *)
(* fn : string * pattern -> int *)
fun count_some_var (x, p) =
  g (fn () => 0) (fn s => if x = s then 1 else 0) p

(* 10 *)
(* fn : pattern -> bool *)
fun check_pat p =
  let
    fun get_strings p =
      case p of
        Variable s => [s]
      | TupleP ps => List.foldl (fn (x, vs) => (get_strings x) @ vs) [] ps
      | ConstructorP (_, x) => get_strings x
      | _ => []
    fun is_repeated strs =
      case strs of
        [] => false
      | x::xs' => (List.exists (fn s => s = x) xs') orelse (is_repeated xs')
  in
    not(is_repeated(get_strings p))
  end

(* 11 *)
(* fn : valu * pattern -> (string * valu) list option *)
fun match(v, p) =
  case (v, p) of
    (_, Wildcard) => SOME []
  | (v', Variable s) => SOME [(s, v')]
  | (Unit, UnitP) => SOME []
  | (Const i, ConstP j) => if i = j then SOME [] else NONE
  | (Tuple vs, TupleP ps) =>
      if List.length vs <> List.length ps
      then NONE
      else all_answers match (ListPair.zip(vs, ps))
  | (Constructor(x, v), ConstructorP(y, p)) =>
      if (x = y)
      then match(v, p)
      else NONE
  | _ => NONE

(* 12 *)
(* fn : valu -> pattern list -> (string * valu) list option *)
fun first_match v ps =
  SOME (first_answer (fn x => match(v, x)) ps)
  handle NoAnswer => NONE


(**** for the challenge problem only ****)

datatype typ = Anything
        | UnitT
        | IntT
        | TupleT of typ list
        | Datatype of string