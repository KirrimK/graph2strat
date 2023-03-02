open State_machine;;
open Compiler;;
open Utils;;

let usage_msg = "Usage: g2s <dot_input_file> [-o <python_output_file>]"
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
  if !input_file = "" then
    Printf.printf "%s\n" usage_msg
  else
    (* Reads from file *)
    let () = Printf.printf "g2s by KirrimK@ENAC version %s\nParsing input file name...\n" version in
  
    let output_file = Array.of_list (String.split_on_char '.' !input_file) in
    let () = output_file.(Array.length output_file - 2) <- output_file.(Array.length output_file - 2) ^ "_g2s" in
    let () = output_file.(Array.length output_file - 1) <- "py" in
    let output_file_str = if !output_dest = "" then String.concat "." (Array.to_list output_file) else !output_dest in
  
    let output_file_lib = Array.of_list (String.split_on_char '/' output_file_str) in
    let () = output_file_lib.(Array.length output_file_lib - 1) <- "statemachine.py" in
    let lib_file_str = String.concat "/" (Array.to_list output_file_lib) in
    let () = Printf.printf "Input file name parsed. Output file name is %s and library will be copied at %s.\n" output_file_str lib_file_str in
    let () = Printf.printf "Reading file...\n" in
  
    let input = read_file !input_file in
    let () = Printf.printf "Reading file done.\nParsing file...\n" in
    let oc = open_out output_file_str in
    let lexbuf = Lexing.from_string (input ^ "\n") in
    let stm = Parser.main Lexer.token lexbuf in
    let () = Printf.fprintf oc "%s" (include_compile stm) in
    let () = close_out oc in
    let () = Printf.printf "Parsed file successfully. Output written to %s\n" output_file_str in
    let lib_oc = open_out lib_file_str in
    let () = Printf.fprintf lib_oc "%s" lib in
    let () = close_out lib_oc in
    Printf.printf "Library written to %s. Goodbye.\n" lib_file_str
