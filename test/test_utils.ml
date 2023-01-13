(* Test_utils.ml *)

let generic_test = fun function_to_test test_name input expected () ->
  try
    let output = (function_to_test ()) input in
    let is_as_expected = (output = expected) in
    (test_name, Ok(is_as_expected))
  with e ->
    (test_name, Error(Printexc.to_string e))

let generic_fail_test = fun function_to_test test_name input expected_failure_message () ->
  try
    let _ = function_to_test input in
    (test_name, Error("Expected failure, but got success"))
  with e ->
    let got = (Printexc.to_string e) in
    (*let () = Printf.printf "  Got:      %s\n" got in
    let () = Printf.printf "  Expected: %s\n" expected_failure_message in*)
    (test_name, Ok(got = expected_failure_message))

let run_tests_and_display = fun test_type_str test_list ->
  Printf.printf "Running tests [%s]\n" test_type_str;
  let total_tests = List.length test_list in
  let res_list = List.map (fun x -> x ()) test_list in
  let ok_count = ref 0 in
  ignore (List.map (fun x -> let (test_name, res) = x in
                              begin match res with
                                Ok(b) -> if b then
                                            ok_count := !ok_count + 1
                                          else Printf.printf "[%s %s] failed\n" test_type_str test_name
                              | Error(msg) -> Printf.printf "[%s %s] failed with error: %s\n" test_type_str test_name msg end) res_list);
  Printf.printf "%d/%d [%s] tests have passed" !ok_count total_tests test_type_str