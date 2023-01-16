open Compiler;;
open Utils;;

(* Regex to match start of graph template zone *)
let reg_graph_templ = Re2.create_exn
    "(.*)\"\"\"STATES_BEGIN(?s)(.*)STATES_END\"\"\"";;

(* Regex to match start of graph external file declaration *)
let reg_ext_graph = Re2.create_exn
    "(.*)\"\"\"STATES_FILE:(.*)\"\"\"";;

(* Regex to match start of placeholders template zone *)
let reg_plhld_templ = Re2.create_exn
    "(.*)\"\"\"HANDLERSPL_BEGIN(?s)(.*)HANDLERSPL_END\"\"\"";;

let ignore_re = Re2.create_exn "IGNORE (.*)"

let template_replace = fun input ->
    (* Extract graph from input *)
    let spacing_g, raw_g, ext =
    try (* Try to extract the graph contained in python file *)
        let find_g = Re2.find_submatches_exn reg_graph_templ input in
        let spacing_g = String.length (Option.get (find_g.(1))) in
        let raw_g = Option.get (find_g.(2)) in
        spacing_g, raw_g, false
    with _ -> (* No graph was contained in python file, try to find external graph declaration *)
        let find_g = Re2.find_submatches_exn reg_ext_graph input in
        let spacing_g = String.length (Option.get (find_g.(1))) in
        let file_name = Option.get (find_g.(2)) in
        let file_ic = open_in file_name in
        let raw_g = really_input_string file_ic (in_channel_length file_ic) in
        let () = close_in file_ic in
        spacing_g, raw_g, true
    in
    (* Convert graph and get information *)
    let lexbuf = Lexing.from_string (raw_g ^ "\n") in
    let stm = Parser.main Lexer.token lexbuf in
    let graph = graph_to_python spacing_g stm in
    (* Extract placeholder ignores from input *)
    let spacing_p, raw_p, has_pl_field = try
        let find_p = Re2.find_submatches_exn reg_plhld_templ input in
        let spacing_p = String.length (Option.get (find_p.(1))) in
        let raw_p = Option.get (find_p.(2)) in
        spacing_p, raw_p, true
    with _ ->
        0, "", false
    in
    (* Extract IGNORES from input *)
    let placeholders = if has_pl_field then
        let ignore_list = try List.map (fun x -> String.sub x 7 ((String.length x)-7)) (Re2.find_all_exn ignore_re raw_p) with _ -> [] in
        let pl_names = find_functions stm in
        gen_place_holders ignore_list spacing_p pl_names
    else 
        ""
    in
    (* Replace graph in input *)
    let spacing_g_str = String.make spacing_g ' ' in 
    let graph_w_header = spacing_g_str ^ "# [graph2strat generated states and transitions]" ^ "\n" ^ graph ^ "\n" ^ spacing_g_str ^ "# [end of generated content]" in
    
    let input_graph_replaced = if ext then Re2.rewrite_exn reg_ext_graph ~template:graph_w_header input else Re2.rewrite_exn reg_graph_templ ~template:graph_w_header input in
    
    (* Replace placeholders in input *)
    let spacing_p_str = String.make spacing_p ' ' in
    let pl_w_header = if not has_pl_field then "" else spacing_p_str ^  "# [graph2strat generated placeholder handlers]" ^ "\n" ^ placeholders ^ "\n" ^ spacing_p_str ^ "# [end of generated content]" in
    let input_all_replaced = Re2.rewrite_exn reg_plhld_templ ~template:pl_w_header input_graph_replaced in
    let file_header = Printf.sprintf "# File generated using graph2strat by KirrimK@ENAC v%s\n# Don't forget to import the contents of statemachine.py: State, Transition, StateMachine\n" version in
    file_header ^ input_all_replaced;;
