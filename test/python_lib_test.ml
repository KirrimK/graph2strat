open Test_utils;;

Random.self_init ();;

let generate_random_file_name = fun () ->
  let num = Random.bits () in
  "/tmp/graph2strattests/" ^ (string_of_int num) ^ ".py";;

let fuse_content_lib = fun content_file ->
  State_machine.lib ^ "\n" ^ content_file;;

let write_to_test_file = fun filename content_file ->
  let oc = open_out filename in
  let () = Printf.fprintf oc "%s" content_file in
  close_out oc;;

let rec read_inch = fun inc acc ->
  try
    read_inch inc (acc ^ (really_input_string inc 1))
  with _ -> acc;;

let exec_python_code = fun file ->
  let inp = Unix.open_process_in ("python3 " ^ file) in
  let r = read_inch inp "" in
  close_in inp; r

let fuse_exec_python_code = fun file_content ->
  let filename = generate_random_file_name () in
  let () = write_to_test_file filename (fuse_content_lib file_content) in
  let result = exec_python_code filename in result;;

let generic_lib_test = generic_test (fun () -> fuse_exec_python_code);;

let test_no_syntax_error = generic_lib_test
    "no_syntax_error"
    ""
    "";;

let test_empty = generic_lib_test
    "state_machine_empty"
    "bruh = StateMachine()
print(bruh)"
    "StateMachine(None)\n";;

let test_init_state = generic_lib_test
    "state_machine_init_state"
    "stonks = State(\"stonks\")
bruh = StateMachine(stonks)
print(stonks)
print(bruh)"
    "State(stonks, [])\nStateMachine(State(stonks, []))\n";;

let test_two_states_unidir = generic_lib_test
    "two_states_unidir"
    "a = State(\"a\")
b = State(\"b\", transitions=[Transition(\"b_to_a\", a)])
print(a)
print(b)
stm = StateMachine(b)
print(stm)
stm.start()
print(stm)
stm.check_transitions()
print(stm)"
    "State(a, [])
State(b, [Transition(b_to_a) ])
StateMachine(State(b, [Transition(b_to_a) ]))
b: on_enter_default
StateMachine(State(b, [Transition(b_to_a) ]))
b_to_a: accept_by_default
b: on_leave_default
b_to_a: nothing
a: on_enter_default
StateMachine(State(a, []))\n";;

let test_two_states_bidir = generic_lib_test
    "two_states_bidir"
    "a = State(\"a\")
b = State(\"b\", transitions=[Transition(\"b_to_a\", a)])
a.add_transition(Transition(\"a_to_b\", b))
print(a)
print(b)
stm = StateMachine(b)
print(stm)
stm.start()
print(stm)
stm.check_transitions()
print(stm)
stm.check_transitions()
print(stm)"
    "State(a, [Transition(a_to_b) ])
State(b, [Transition(b_to_a) ])
StateMachine(State(b, [Transition(b_to_a) ]))
b: on_enter_default
StateMachine(State(b, [Transition(b_to_a) ]))
b_to_a: accept_by_default
b: on_leave_default
b_to_a: nothing
a: on_enter_default
StateMachine(State(a, [Transition(a_to_b) ]))
a_to_b: accept_by_default
a: on_leave_default
a_to_b: nothing
b: on_enter_default
StateMachine(State(b, [Transition(b_to_a) ]))\n";;

let test_two_states_bidir_custom_funcs = generic_lib_test
    "two_states_bidir_custom_funcs"
    "
def ae():
    print(\"ae\")
def be():
    print(\"be\")
def al():
    print(\"al\")
def bl():
    print(\"bl\")
def a2b():
    print(\"a2b\")
def b2a():
    print(\"b2a\")
CHECKA2B = False
def guarda2b():
    return CHECKA2B
CHECKB2A = False
def guardb2a():
    return CHECKB2A
a = State(\"a\", ae, al)
b = State(\"b\", be, bl, [Transition(\"b_to_a\", a, b2a, guardb2a)])
a.add_transition(Transition(\"a_to_b\", b, a2b, guarda2b))
print(a)
print(b)
stm = StateMachine(b)
print(stm)
stm.start()
print(stm)
stm.check_transitions()
CHECKB2A = True
print(stm)
stm.check_transitions()
print(stm)
stm.check_transitions()
print(stm)
CHECKA2B = True
stm.check_transitions()
print(stm)"
    "State(a, [Transition(a_to_b) ])
State(b, [Transition(b_to_a) ])
StateMachine(State(b, [Transition(b_to_a) ]))
be
StateMachine(State(b, [Transition(b_to_a) ]))
StateMachine(State(b, [Transition(b_to_a) ]))
bl
b2a
ae
StateMachine(State(a, [Transition(a_to_b) ]))
StateMachine(State(a, [Transition(a_to_b) ]))
al
a2b
be
StateMachine(State(b, [Transition(b_to_a) ]))
";;

Sys.chdir "../../../test/test_files/python_lib";;
Sys.command "mkdir /tmp/graph2strattests/";;
let () = run_tests_and_display "PYTHON_LIB" [
  test_no_syntax_error;
  test_empty;
  test_init_state;
  test_two_states_unidir;
  test_two_states_bidir;
  test_two_states_bidir_custom_funcs;
];;
Sys.command "rm -rf /tmp/graph2strattests";;
