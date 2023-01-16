open Test_utils;;
open Templating;;

let generic_template_replace_test = generic_test (fun () -> template_replace);;
let generic_template_replace_fail_test = generic_fail_test template_replace;;

let generic_template_replace_test_files = generic_test_files (fun () -> template_replace);;

let test_none = generic_template_replace_fail_test
  "test_none"
  ""
  "Re2__Regex.Exceptions.Regex_match_failed(\"(.*)\\\"\\\"\\\"STATES_FILE:(.*)\\\"\\\"\\\"\")";;

let test_empty_field = generic_template_replace_fail_test
  "test_empty_field"
  "\"\"\"STATES_BEGIN 
  
  STATES_END\"\"\""
  "Parser.MenhirBasics.Error";;

let test_empty_machine_no_pl = generic_template_replace_test
  "test_empty_machine_no_pl"
  "\"\"\"STATES_BEGIN
digraph stonks {

}
STATES_END\"\"\""

"# File generated using graph2strat by KirrimK@ENAC vunknown
# Don't forget to import the contents of statemachine.py: State, Transition, StateMachine
# [graph2strat generated states and transitions]


self.stonks = StateMachine(None)
# [end of generated content]"

let test_one_state_machine_no_pl_explicit = generic_template_replace_test
  "one_state_machine_no_pl_explicit"
  "\"\"\"STATES_BEGIN
#init Init
digraph stonks {
  Init [comment=\"\"]
}
STATES_END\"\"\""

"# File generated using graph2strat by KirrimK@ENAC vunknown
# Don't forget to import the contents of statemachine.py: State, Transition, StateMachine
# [graph2strat generated states and transitions]
Init = State(\"Init\")

self.stonks = StateMachine(Init)
# [end of generated content]"

let test_one_state_machine_no_pl_implicit = generic_template_replace_test
  "one_state_machine_no_pl_implicit"
  "\"\"\"STATES_BEGIN
#init Init
digraph stonks {

}
STATES_END\"\"\""

"# File generated using graph2strat by KirrimK@ENAC vunknown
# Don't forget to import the contents of statemachine.py: State, Transition, StateMachine
# [graph2strat generated states and transitions]
Init = State(\"Init\")

self.stonks = StateMachine(Init)
# [end of generated content]"

let test_files_empty_machine = generic_template_replace_test_files
  "test_files_empty_machine"
  "test/test_files/empty_machine.py"
  "test/test_files/empty_machine.expected";;

let test_files_empty_machine_with_pl = generic_template_replace_test_files
  "test_files_empty_machine_with_pl"
  "test/test_files/empty_machine_with_pl.py"
  "test/test_files/empty_machine_with_pl.expected";;

let () = run_tests_and_display "CONVERT" [
  (*test_none;
  test_empty_field;
  test_empty_machine_no_pl;
  test_one_state_machine_no_pl_explicit;
  test_one_state_machine_no_pl_implicit;*)
  test_files_empty_machine;
  test_files_empty_machine_with_pl;
]