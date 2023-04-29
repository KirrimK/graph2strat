(* Compiler.ml *)
open Utils;;

(* Type definitions *)
type statement = 
  State of string * string
| Transition of string list * string * string

type statemachine = 
  StateMachine of string option * string * (statement list);;

(* String functions for debug *)
let st_str = fun st ->
  match st with
    State(id, on_enter_and_on_leave) -> Printf.sprintf "{[%s] %s}" id on_enter_and_on_leave
  | Transition(id_ls, idb, guard) -> Printf.sprintf "{[{%s} -> %s] %s}" (String.concat ", " id_ls) idb guard;;

let stm_str = fun stm ->
  match stm with
    StateMachine(init, name, st_ls) ->
    Printf.sprintf "StateMachine [init %s] [name %s]{\n\t%s\n}" (match init with Some x -> x | _ -> "None") name (String.concat "\n\t" (List.map st_str st_ls));;

(* Compiling dot graph to state machine *)

let statement_to_python = fun spacing st ->
  let spacing_str = String.make spacing ' ' in
  match st with
    State(id, on_enter_and_on_leave) ->
      (* Transform string from format "enter:x;leave:x;loop:x" to format "on_enter=x, on_leave=x, on_loop=x" *)
      let on_enter_and_on_leave_py = String.concat ", "
        (List.map (fun x -> match String.split_on_char ':' x with
                            | [a; b] when List.mem (String.trim a) ["enter"; "leave"; "loop"] ->
                              Printf.sprintf "on_%s=self.parent.%s" (String.trim a) (String.trim b) 
                            | [a; _] -> failwith (Printf.sprintf "incorrect format in st (unknown type: %s): %s" (String.trim a) x)
                            | [""] -> ""
                            | _ -> failwith (Printf.sprintf "incorrect format in st (expected type:func_name): %s" x)) 
          (String.split_on_char ';' on_enter_and_on_leave)) in
      Printf.sprintf "%sself.%s = State(\"%s\", %s)" spacing_str id id on_enter_and_on_leave_py
  | Transition(id_ls, idb, guard) ->
      let full_name = String.concat "To" [(String.concat "" id_ls); idb] in
      let short_name = if String.length full_name > 30 then "tr" ^ (string_of_int (Hashtbl.hash (full_name))) else full_name in
      let declaration = Printf.sprintf "%sself.%s = Transition(\"%s\", self.%s, %s)" spacing_str short_name short_name idb (if guard = "" then guard else "self.parent."^guard) in
      let state_transition_register = String.concat "\n"
                                        (List.map (fun x -> Printf.sprintf "%sself.%s.add_transition(self.%s)" spacing_str x short_name) id_ls) in
      declaration ^ "\n" ^ state_transition_register

let graph_to_python = fun spacing stm ->
  let StateMachine(init, name, st_ls) = stm in
  let spacing_str = String.make spacing ' ' in
  (* Separating states and transitions *)
  let state_list = List.filter (fun x -> match x with State(_, _) -> true | _ -> false) st_ls in
  let state_names = List.map (fun x -> match x with State(a, _) -> a | _ -> failwith "Impossible") state_list in
  let transition_list = List.filter (fun x -> match x with Transition(_, _, _) -> true | _ -> false) st_ls in
  (* Inferring missing states *)
  let infer_states = fun tr ->
    match tr with
      Transition(orig_ls, dest, _) ->
        let missing_states = List.filter (fun x -> not (List.mem x state_names)) (dest::orig_ls) in
        List.map (fun x -> State(x, "")) missing_states
    | _ -> failwith "Impossible" in
  let inferred_states = List.concat (List.map infer_states transition_list) in
  (* Removing duplicate states *)
  let big_state_list = inferred_states @ state_list in
  let uniq_state_list = uniq big_state_list in
  (* Converting states to python *)
  let states_python = String.concat "\n" (List.map (statement_to_python spacing) uniq_state_list) in
  (* Converting transitions to python *)
  let transitions_python = String.concat "\n" (List.map (statement_to_python spacing) transition_list) in
  (* Creating the state machine *)
  let state_machine = Printf.sprintf "%sself.%s = StateMachine(self.%s)" spacing_str
                        name (match init with Some x -> x | _ -> "None") in
  (* Adding states to the state machine *)
  states_python ^ "\n" ^ transitions_python ^ "\n" ^ state_machine;;
