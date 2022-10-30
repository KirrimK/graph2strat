open Templating;;
(*open State_machine;;*)

let usage_msg = "graph2stratcompiler [<file>]"
let input_file = ref ""
(*let need_lib = ref false *)

let speclist =
  [(*("--lib", Arg.Set need_lib, "Get the statemachine library to be used with auto-generated graphs. Should be called statemachine.py")*)];;

let anon_fun = fun filename->
  input_file := filename

let rec read_stdin = fun acc ->
  try
    read_stdin (String.concat "" [acc; (really_input_string stdin 1)])
  with _ -> acc;;

let () =
  Arg.parse speclist anon_fun usage_msg;
  if !input_file = "" then
      (* Reads from stdin *)
      let input = read_stdin "" in
      Printf.printf "%s" (template_replace input)
  else
    (* Reads from file *)
    let ic = open_in !input_file in
    let input = really_input_string ic (in_channel_length ic) in
    let () = close_in ic in
    Printf.printf "%s" (template_replace input)