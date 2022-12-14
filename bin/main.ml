open Templating;;
open State_machine;;
open Utils;;

let usage_msg = "graph2stratcompiler (--lib) [<file>]"
let input_file = ref ""
let output_dest = ref ""
let need_lib = ref false

let speclist =
  [
    ("--lib", Arg.Set need_lib, "Get the statemachine library to be used with auto-generated graphs on stdout. Don't forget to import its contents inside your templates.");
    ("-o", Arg.Set_string output_dest, "Output file. Default is <input_file_name>_gen.py .")
  ];;

let anon_fun = fun filename->
  input_file := filename

let rec read_stdin = fun acc ->
  try
    read_stdin (String.concat "" [acc; (really_input_string stdin 1)])
  with _ -> acc;;

let () =
  Arg.parse speclist anon_fun usage_msg;
  if !need_lib then
    Printf.printf "%s" lib
  else
    if !input_file = "" then
        (* Reads from stdin *)
        let input = read_stdin "" in
        Printf.printf "%s" (template_replace input)
    else
      (* Reads from file *)
      let () = Printf.printf "graph2stratcompiler by KirrimK@ENAC version %s\nParsing input file name...\n" version in
      
      let output_file = Array.of_list (String.split_on_char '.' !input_file) in
      let () = output_file.(Array.length output_file - 2) <- output_file.(Array.length output_file - 2) ^ "_gen" in
      let output_file_str = if !output_dest = "" then String.concat "." (Array.to_list output_file) else !output_dest in
      
      let output_file_lib = Array.of_list (String.split_on_char '/' output_file_str) in
      let () = output_file_lib.(Array.length output_file_lib - 1) <- "statemachine.py" in
      let lib_file_str = String.concat "/" (Array.to_list output_file_lib) in
      let () = Printf.printf "Input file name parsed. Output file name is %s and library will be copied at %s.\n" output_file_str lib_file_str in
      let () = Printf.printf "Reading file...\n" in
      
      let ic = open_in !input_file in
      let input = really_input_string ic (in_channel_length ic) in
      let () = close_in ic in
      let () = Printf.printf "Reading file done.\nParsing file...\n" in
      let oc = open_out output_file_str in
      let () = Printf.fprintf oc "%s" (template_replace input) in
      let () = close_out oc in
      let () = Printf.printf "Parsed file successfully. Output written to %s\n" output_file_str in
      let lib_oc = open_out lib_file_str in
      let () = Printf.fprintf lib_oc "%s" lib in
      let () = close_out lib_oc in
      Printf.printf "Library written to %s. Goodbye.\n" lib_file_str
