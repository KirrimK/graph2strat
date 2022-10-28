open Compiler;;

let converter_graph = fun spacing raw ->
  let lexbuf = Lexing.from_string (String.concat "" [raw; "\n"]) in
  let stm = Parser.main Lexer.token lexbuf in
  (graph_to_python spacing stm, stm)

let ignore_re = Re2.create_exn "IGNORE (.*)"

let converter_placeholders = fun stm spacing raw ->
  let ignore_list = List.map (fun x -> String.sub x 7 ((String.length x)-7)) (Re2.find_all_exn ignore_re raw) in
  let pl_names = find_functions stm in
  (gen_place_holders ignore_list spacing pl_names, ignore_list)