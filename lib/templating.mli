val reg_graph_templ: Re2.t
val reg_plhld_templ: Re2.t

val replace_graph_in_string: string -> (int -> string -> string * Compiler.statemachine) -> (string * Compiler.statemachine)
val replace_plhld_in_string: string -> (int -> string -> string * string list) -> (string * string list)