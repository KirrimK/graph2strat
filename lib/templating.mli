(** Templating module *)

(** Regex for capturing the Graph declaration box *)
val reg_graph_templ : Re2.t

(* Regex to match start of graph external file declaration *)
val reg_ext_graph : Re2.t

(** Regex for capturing the Placeholders declaration box *)
val reg_plhld_templ : Re2.t

(** Regex for capturing the IGNORE <func name> in the template *)
val ignore_re : Re2.t

(** Extracts the information (graph, placeholders) from the various fields in the template, 
    processes it into python code, and injects it back
    @param input the file to be processed
    @return the file after processing
*)
val template_replace : string -> string
