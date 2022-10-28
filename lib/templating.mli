(** Module handling Templating for autoreplacing template code by generated code *)

val reg_graph_templ : Str.regexp
val reg_plhld_templ : Str.regexp
val replace_in_string :
  Str.regexp ->
  string -> string -> string -> (int -> string -> string) -> string
val replace_graph_in_string : string -> (int -> string -> string) -> string
val replace_plhld_in_string : string -> (int -> string -> string) -> string
