open Compiler;;

(* Regex to match start of graph template zone *)
let reg_graph_templ = Re2.create_exn
    "(.*)\"\"\"STATES_BEGIN(?s)(.*)STATES_END\"\"\"";;

(* Regex to match start of placeholders template zone *)
let reg_plhld_templ = Re2.create_exn
    "(.*)\"\"\"HANDLERSPL_BEGIN(?s)(.*)HANDLERSPL_END\"\"\"";;

let ignore_re = Re2.create_exn "IGNORE (.*)"

let template_replace = fun input ->
    (* Extract graph from input *)
    let find_g = Re2.find_submatches_exn reg_graph_templ input in
    let spacing_g = String.length (Option.get (find_g.(1))) in
    let raw_g = Option.get (find_g.(2)) in
    (* Convert graph and get information *)
    let lexbuf = Lexing.from_string (raw_g ^ "\n") in
    let stm = Parser.main Lexer.token lexbuf in
    let graph = graph_to_python spacing_g stm in
    (* Extract placeholder ignores from input *)
    let find_p = Re2.find_submatches_exn reg_plhld_templ input in
    let spacing_p = String.length (Option.get (find_p.(1))) in
    let raw_p = Option.get (find_p.(2)) in
    (* Extract IGNORES from input *)
    let ignore_list = List.map (fun x -> String.sub x 7 ((String.length x)-7)) (Re2.find_all_exn ignore_re raw_p) in
    let pl_names = find_functions stm in
    let placeholders = gen_place_holders ignore_list spacing_p pl_names in
    (* Replace graph in input *)
    let spacing_g_str = String.make spacing_g ' ' in 
    let graph_w_header = spacing_g_str ^ "# [graph2strat generated states and transitions]" ^ "\n" ^ graph ^ "\n" ^ spacing_g_str ^ "# [end of generated content]" in
    let input_graph_replaced = Re2.rewrite_exn reg_graph_templ ~template:graph_w_header input in
    (* Replace placeholders in input *)
    let spacing_p_str = String.make spacing_p ' ' in
    let pl_w_header = spacing_p_str ^ "# [graph2strat generated placeholder handlers]" ^ "\n" ^ placeholders ^ "\n" ^ spacing_p_str ^ "# [end of generated content]" in
    let input_all_replaced = Re2.rewrite_exn reg_plhld_templ ~template:pl_w_header input_graph_replaced in
    input_all_replaced;;
