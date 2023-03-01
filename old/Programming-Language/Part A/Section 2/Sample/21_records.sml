(* Programming Languages, Dan Grossman *)
(* Section 2: Compound type and Records *)

(* basic type: int, bool, uint, char
 * compound types: tuples, lists, options
 ---
 * Each of: contains values of each of t1, t2 ... tn
    * tuple: `int` and `bool
 * One of: contains values of one of t1, t2 ... tn
    * int option: `int` or no data
 * Self reference: refer to other t value
 *)

(* Records: we needn't to declare our types in ML
 * {f1 = v1, ..., fn = vn} >-> {f1 : t1, ..., fn : tn}
 * Accessing pieces: #myfieldname e
 ---
 * tuple a little shorter, record a liitle easier to remember "what is where"
 * by position(as in tuples), by name(as with records)
 *)


val x = {bar = (1+2,true andalso true), foo = 3+4, baz = (false,9)}

val my_niece = {id = 41123 - 12, name = "Amelia"}
val niece_id = #id my_niece
val niece_name = #name my_niece

val brain_part = {id = true, ego = false, superego = false}
