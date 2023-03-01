(* Programming Languages, Dan Grossman *)
(* Section 2: Exceptions *)

fun hd xs =
    case xs of
        []   => raise List.Empty
      | x::_ => x

exception MyUndesirableCondition

exception MyOtherException of int * int
(* raise MyOtherException(3,4) *)

fun mydiv (x,y) =
    if y=0
    then raise MyUndesirableCondition
    else x div y

fun maxlist (xs,ex) = (* int list * exn -> int *)
    case xs of
        [] => raise ex
      | x::[] => x
      | x::xs' => Int.max(x,maxlist(xs',ex))

val w = maxlist ([3,4,5],MyUndesirableCondition) (* 5 *)

val x = maxlist ([3,4,5],MyUndesirableCondition) (* 5 *)
    handle MyUndesirableCondition => 42 (* catch exception *)

(*val y = maxlist ([],MyUndesirableCondition)*)

val z = maxlist ([],MyUndesirableCondition) (* 42 *)
    handle MyUndesirableCondition => 42

exception MyException of int
fun f n =
    if n=0 then raise List.Empty
    else if n=1 then raise (MyException 4)
         else n * n
val x = (f 1 handle List.Empty => 42) handle MyException n => f n