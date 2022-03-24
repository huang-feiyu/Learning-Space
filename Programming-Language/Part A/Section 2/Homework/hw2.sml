(* hw2.sml
 * author: Huang
 * description: the solution to Coursera Programmin-Language Section 2
 *)

(* problem 1: name substitutions *)
fun same_string(s1 : string, s2 : string) =
  s1 = s2

(* 1a *)
(* fn : string * string list -> string list option *)
fun all_except_option(str : string, strs : string list) =
  case strs of
    [] => NONE
  | x::xs' => if same_string(str, x) then SOME(xs')
              else case all_except_option(str, xs') of
                    NONE => NONE
                  | SOME(ans) => SOME(x::ans)

(* 1b *)
(* fn : string list list * string -> string list *)
fun get_substitutions1(strlists : string list list, str : string) =
  case strlists of
    [] => []
  | x::xs' => case all_except_option(str, x) of
                NONE => get_substitutions1(xs', str)
              | SOME(ans) => ans @ get_substitutions1(xs', str)

(* 1c *)
(* fn : string list list * string -> string list *)
fun get_substitutions2(strlists : string list list, str : string) =
  let fun aux(mylists, acc) =
    case mylists of
      [] => acc
    | x::xs' => case all_except_option(str, x) of
                  NONE => aux(xs', acc)
                | SOME(ans) => aux(xs', ans @ acc)
  in
    aux(strlists, [])
  end

(* 1d, compose first name with others *)
(* fn : string list list * Name -> Name list *)
type Name = {first:string, last:string, middle:string}

fun similar_names(strlists : string list list, name : Name) =
  let
    val {first=fst, middle=mid, last=lst} = name
    fun aux(mylists, acc) =
    case mylists of
      [] => acc
    | x::xs =>
      aux(xs, {first=x, middle=mid, last=lst} :: acc)
  in
    aux(get_substitutions2(strlists, fst), [name])
  end


(* problem 2 *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw

exception IllegalMove

(* 2a *)
(* fn : card -> color *)
fun card_color(s : suit, r : rank) =
  case s of
    Clubs => Black
  | Diamonds => Red
  | Hearts => Red
  | Spades => Black

(* 2b *)
(* fn : card -> int *)
fun card_value(s : suit, r : rank) =
  case r of
    Num n => n
  | Ace => 11
  | _ => 10

(* 2c *)
(* fn : card list * card * exn -> card list *)
fun remove_card(cs : card list, c : card, e : exn) =
  case cs of
    [] => raise e
  | x::xs' => case c = x of
                true => xs'
              | false => x :: remove_card(xs', c, e)

(* 2d *)
(* fn : card list -> bool *)
fun all_same_color(cs : card list) =
  case cs of
    [] => true
  | x::[] => true
  | c1::c2::xs' =>
    card_color(c1) = card_color(c2) andalso all_same_color(c2::xs')

(* 2e *)
(* fn : card list -> int *)
fun sum_cards(cs : card list) =
  let
    fun aux(mycs, acc) =
    case mycs of
      [] => acc
    | x::xs' => card_value(x) + aux(xs', acc)
  in
    aux(cs, 0)
  end

(* 2f *)
(* fn : card list * int -> int *)
fun score(cs : card list, g : int) =
  let
    val sum = sum_cards(cs)
    val preliminary_score = if sum > g then 3 * (sum - g) else g - sum
  in
    if all_same_color(cs)
    then preliminary_score div 2
    else preliminary_score
  end

(* 2g *)
(* fn : card list * move list * int -> int *)
fun officiate(cs : card list, ms : move list, g : int) =
  let
    fun aux(mycs, myms, held_list) =
    case myms of
      [] => score(held_list, g)
    | (Discard c)::tl =>
      aux(mycs, tl, remove_card(held_list, c, IllegalMove))
    | Draw::tl =>
      case mycs of
        [] => score(held_list, g)
      | x::xs' =>
        let val sum = sum_cards(x::held_list)
        in
          if sum > g then score(x::held_list, g)
          else aux(xs', tl, x::held_list)
        end
  in
    aux(cs, ms, [])
  end
