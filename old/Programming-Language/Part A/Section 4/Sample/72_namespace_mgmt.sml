(* Programming Languages, Dan Grossman *)
(* Section 4: Modules for Namespace Management *)

(* module:
  1. inside a module, can use earlier bindings as usual
  2. outside a module, refer to earlier modules' bindings via ModuleName.bindingName
  * Syntax:
    strucutre ModuleName =
    struct
    mybindings
    end
  * Namespace management
  * use `open` to get direct access to a module's bindings
    just like Python's `from xx import *`
*)

structure MyMathLib =
struct

fun fact x =
  if x=0
  then 1
  else x * fact (x - 1)

val half_pi = Math.pi / 2.0

fun doubler y = y + y

end

val pi = MyMathLib.half_pi + MyMathLib.half_pi

val twenty_eight = MyMathLib.doubler 14
