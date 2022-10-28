(* Regex to match start of graph template zone *)
let reg_graph_templ = Re2.create_exn
    "(.*)\"\"\"STATES_BEGIN(?s)(.*)STATES_END\"\"\"";;

(* Regex to match start of placeholders template zone *)
let reg_plhld_templ = Re2.create_exn
    "(.*)\"\"\"HANDLERSPL_BEGIN(?s)(.*)HANDLERSPL_END\"\"\"";;

let replace_in_string = fun reg header footer input converter ->
    let azerty = Re2.find_submatches_exn reg input in
    let spacing = String.length (Option.get (azerty.(1))) in
    let raw = Option.get (azerty.(2)) in
    let (converted, outconv) = converter spacing raw in
    let header = String.make spacing ' ' ^ header in
    let footer = String.make spacing ' ' ^ footer in
    let content = header ^ "\n" ^ converted ^ "\n" ^ footer in
    (Re2.rewrite_exn reg ~template:content input, outconv);;

let replace_graph_in_string = replace_in_string
    reg_graph_templ
    "# [graph2strat generated states and transitions]"
    "# [end of generated content]";;

let replace_plhld_in_string = replace_in_string
    reg_plhld_templ
    "# [graph2strat generated placeholder handlers]"
    "# [end of generated content]";;
