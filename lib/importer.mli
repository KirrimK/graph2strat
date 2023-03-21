(** Importer module *)

(** Converts a statemachine into a python importable file (as a string)
    Bundles the statemachine library and the statemachine into a single file
    @param stm the statemachine to convert
    @return the python code as a string
*)
val include_compile : Compiler.statemachine -> string
