(* Compiler.ml *)

(* Type definitions *)
type statement = 
  State of string * string
| Transition of string list * string * string

type statemachine = 
  StateMachine of string option * string * (statement list);;

(* String functions for debug *)
let st_str = fun st ->
  match st with
    State(id, on_enter_and_on_leave) -> Printf.sprintf "State [%s] enter/leave[%s]" id on_enter_and_on_leave
  | Transition(id_ls, idb, guard_and_on_transition) -> Printf.sprintf "Transition [{%s} -> %s] guard/on_transition[%s]" (String.concat ", " id_ls) idb guard_and_on_transition;;

let stm_str = fun stm ->
  match stm with
    StateMachine(init, imports, st_ls) ->
    Printf.sprintf "StateMachine [init %s] [imports %s]{\n\t%s\n}" (match init with Some x -> x | _ -> "None") imports (String.concat "\n\t" (List.map st_str st_ls));;

(* Compiling dot graph to state machine *)

let state_to_python = fun spacing st ->
  let spacing_str = String.make spacing ' ' in
  match st with
    State(id, on_enter_and_on_leave) ->
      begin match String.split_on_char '/' on_enter_and_on_leave with
        [on_enter; on_leave] -> Printf.sprintf "%s%s = State(\"%s\", %s, %s)" spacing_str id id on_enter on_leave
      | [nope] when nope = "" -> Printf.sprintf "%s%s = State(\"%s\")" spacing_str id id
      | [enter] -> Printf.sprintf "%s%s = State(\"%s\", %s)" spacing_str id id enter
      | _ -> (Printf.sprintf "Invalid State: Too much in state %s" (st_str st))
      end
  | Transition(id_ls, idb, guard_and_on_transition) ->
      let full_name = String.concat "To" [(String.concat "" id_ls); idb] in
      let short_name = if String.length full_name > 30 then "tr" ^ (string_of_int (Hashtbl.hash (full_name))) else full_name in
      let declaration = match String.split_on_char '/' guard_and_on_transition with
        [guard; on_transition] -> Printf.sprintf "%s%s = Transition(%s, %s, %s, %s)" spacing_str short_name short_name idb guard on_transition
      | [nope] when nope = "" -> Printf.sprintf "%s%s = Transition(%s, %s)" spacing_str short_name short_name idb
      | [on_transition] -> Printf.sprintf "%s%s = Transition(%s, %s, %s)" spacing_str short_name short_name idb on_transition
      | _ -> (Printf.sprintf "Invalid Transition: Too much in transition %s" (st_str st)) in
      let state_transition_register = String.concat "\n"
                                        (List.map (fun x -> Printf.sprintf "%s%s.add_transition(%s)" spacing_str x short_name) id_ls) in
      declaration ^ "\n" ^ state_transition_register

let uniq = fun ls ->
  let rec uniq_loc = fun ls_ acc ->
    match ls_ with
      [] -> acc
    | a::b -> if List.mem a acc then
                uniq_loc b acc 
              else uniq_loc b (a::acc) in
  uniq_loc ls [];;

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
  let states_python = String.concat "\n" (List.map (state_to_python spacing) uniq_state_list) in
  (* Converting transitions to python *)
  let transitions_python = String.concat "\n" (List.map (state_to_python spacing) transition_list) in
  (* Creating the state machine *)
  let state_machine = Printf.sprintf "%sself.%s = StateMachine(%s)" spacing_str
                        name (match init with Some x -> x | _ -> "None") in
  (* Adding states to the state machine *)
  states_python ^ "\n" ^ transitions_python ^ "\n" ^ state_machine;;

let gen_place_holders = fun ignores spacing names_ls ->
  let spacing_str = String.make spacing ' ' in
  let place_holders = List.filter_map (fun x -> if List.mem x ignores then None else Some (Printf.sprintf "%sdef %s(self):\n%s    pass\n" spacing_str x spacing_str)) names_ls in
  String.concat "\n" place_holders;;

let find_functions = fun stm ->
  let StateMachine(_, _, st_ls) = stm in
  let find_functions_loc = fun st ->
    match st with
      State(_, on_enter_and_on_leave) ->
        begin match String.split_on_char '/' on_enter_and_on_leave with
          [on_enter; on_leave] -> [on_enter; on_leave]
        | [nope] when nope = "" -> []
        | [enter] -> [enter]
        | _ -> failwith (Printf.sprintf "Invalid State: Too much in state %s" (st_str st))
        end
    | Transition(_, _, guard_and_on_transition) ->
        begin match String.split_on_char '/' guard_and_on_transition with
          [guard; on_transition] -> [guard; on_transition]
        | [nope] when nope = "" -> []
        | [on_transition] -> [on_transition]
        | _ -> failwith (Printf.sprintf "Invalid Transition: Too much in transition %s" (st_str st))
        end in
  let functions = List.concat (List.map find_functions_loc st_ls) in
  uniq functions;;

(* OLD_CODE Compiling dot graph to state machine *)

let generate_fricking_placeholder_functions = fun st ->
  match st with
    State(_, on_enter_and_on_leave) ->
      begin match String.split_on_char '/' on_enter_and_on_leave with
        enter::[leave] -> 
          [Printf.sprintf "def %s(self):\n    pass\n" enter; Printf.sprintf "def %s(self):\n    pass\n" leave]
      | [nope] when nope = "" ->
        [""]
      | [enter] ->
        [Printf.sprintf "def %s(self):\n    pass\n" enter]
      | _ -> failwith (Printf.sprintf "Too much in state %s" (st_str st)) end
  | Transition(_, _, guard_and_on_transition) ->
      begin match String.split_on_char '/' guard_and_on_transition with
        on_transition::[guard] ->
          [Printf.sprintf "def %s(self):\n    pass\n" on_transition; Printf.sprintf "def %s(self):\n    return True\n" guard]
      | [nope] when nope = "" ->
          [""]
      | [on_transition] -> 
          [Printf.sprintf "def %s(self):\n    pass\n" on_transition]
      | _ -> failwith (Printf.sprintf "Too much in transition %s" (st_str st)) end
(*virer les duplicatas*)
let generate_stm_py = fun stm ->
  match stm with
    StateMachine(init, name, st_ls) ->
      let list_states = List.filter (fun x -> match x with State(_, _) -> true | _ -> false) st_ls in
      let list_trs = List.filter (fun x -> match x with State(_, _) -> false | _ -> true) st_ls in

      let infer_states = fun tr->
        match tr with
          Transition(orig_ls, dest , _) -> 
            let state_names = (List.map (fun x -> match x with State(a, _) -> a | _ -> failwith "Error: Transition in st_ls") list_states) in

            let unknown_states = List.filter
              (fun x -> not (List.mem x state_names)) orig_ls in
              List.map (fun x -> State(x, "")) (if List.mem dest state_names then unknown_states else dest::unknown_states) 
        | _ -> failwith "Error: state in tr_list" in
      
      let inferred_states = List.map infer_states list_trs in

      let rec remove_duplicates = fun ls acc ->
        match ls with
          [] -> acc
        | a::b -> if List.mem a acc then remove_duplicates b acc else remove_duplicates b (a::acc) in

      let py_states = List.map (state_to_python 8) (remove_duplicates (List.concat [list_states; List.concat inferred_states]) []) in
      let py_trs = List.map (state_to_python 8) list_trs in
      let all_printed = String.concat "\n" (List.concat [py_states; py_trs]) in
      let py_stm = Printf.sprintf "%s = StateMachine(%s)"
                    name
                      (match init with
                        Some x -> x
                      | None -> "") in

      let placeholders = String.concat "\n" (List.rev (remove_duplicates (List.concat (List.map generate_fricking_placeholder_functions st_ls)) [])) in
      Printf.sprintf "from statemachine import State, Transition, StateMachine\n\n%s\n%s\n%s" all_printed py_stm placeholders