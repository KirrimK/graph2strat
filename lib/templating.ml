(* Regex to match start of graph template zone *)
let reg_graph_templ = Str.regexp
    "(.*)\"\"\"STATES_BEGIN(?s)(.*)STATES_END\"\"\"";;

(* Regex to match start of placeholders template zone *)
let reg_plhld_templ = Str.regexp
    "(.*)\"\"\"HANDLERSPL_BEGIN(?s)(.*)HANDLERSPL_END\"\"\"";;

let replace_in_string = fun reg header footer input converter ->
    let _ = Str.string_match reg input 0 in
    let spacing = String.length (Str.matched_group 1 input) in
    let raw = Str.matched_group 2 input in
    let converted = converter spacing raw in
    let header = String.make spacing ' ' ^ header in
    let footer = String.make spacing ' ' ^ footer in
    let content = header ^ converted ^ footer in
    Str.global_replace reg content input

let replace_graph_in_string = replace_in_string
    reg_graph_templ
    "# graph2strat generated states and transitions"
    "# end of generated content";;

let replace_plhld_in_string = replace_in_string
    reg_plhld_templ
    "# graph2strat generated placeholder handlers"
    "# end of generated content";;
