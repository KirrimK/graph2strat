open Importer;;
open Utils;;

let build_type = [%getenv "BUILD_TYPE"];;

let usage_msg = Printf.sprintf "Usage: %s <dot_input_file> [-o <python_output_file>]" Sys.argv.(0)
let input_file = ref ""
let output_dest = ref ""
let speclist =
  [
    ("-o", Arg.Set_string output_dest, "Output file. Default is <dot_input_file>_g2s.py .")
  ];;

let anon_fun = fun filename->
  input_file := filename

let () =
  Arg.parse speclist anon_fun usage_msg;
  let () = Printf.printf "Graph2strat by KirrimK version %s (Build type: %s)\n" version build_type in
  if !input_file = "" then
    Printf.printf "%s\n" usage_msg
  else
    let output_file_str = if !output_dest <> "" then !output_dest else path_add_name_suffix_change_extension "_g2s" "py" !input_file in
  
    let input = read_file !input_file in
    let lexbuf = Lexing.from_string (input ^ "\n") in
    let stm = Parser.main Lexer.token lexbuf in

    let oc = open_out output_file_str in
    let () = Printf.fprintf oc "%s" (include_compile stm) in
    let () = close_out oc in
    Printf.printf "Parsed file successfully. Output written to %s\n" output_file_str
