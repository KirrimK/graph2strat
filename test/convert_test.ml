open Test_utils;;
open Templating;;

let generic_template_replace_test = generic_test (fun () -> template_replace);;
let generic_template_replace_fail_test = generic_fail_test template_replace;;

let test_none = generic_template_replace_fail_test
  "test_none"
  "input"
  "Re2__Regex.Exceptions.Regex_match_failed(\"(.*)\\\"\\\"\\\"STATES_FILE:(.*)\\\"\\\"\\\"\")";;

let test_empty_field = generic_template_replace_fail_test
  "test_empty_field"
  "\"\"\"STATES_BEGIN 
  
  STATES_END\"\"\""
  "Parser.MenhirBasics.Error";;

let test_empty_machine = generic_template_replace_test
  "test_empty_machine"
  "\"\"\"STATES_BEGIN
  #init Init
  digraph stonks {

  }
  STATES_END\"\"\"
  \"\"\"HANDLERSPL_BEGIN HANDLERSPL_END\"\"\""
  "a"

let () = run_tests_and_display "CONVERT" [
  test_none;
  test_empty_field;
  test_empty_machine;
]