(* Utils *)

let version = (match Build_info.V1.version() with
                  None -> "unknown"
                | Some v -> Build_info.V1.Version.to_string v);;

let uniq = fun ls ->
  let rec uniq_loc = fun ls_ acc ->
    match ls_ with
      [] -> acc
    | a::b -> if List.mem a acc then
                uniq_loc b acc 
              else uniq_loc b (a::acc) in
  uniq_loc ls [];;

let read_file = fun filename ->
  let ic = open_in filename in
  let input = really_input_string ic (in_channel_length ic) in
  let () = close_in ic in
  input;;

let read_stdin = fun () -> 
  let rec local = fun acc ->
    try
     local (String.concat "" [acc; (really_input_string stdin 1)])
    with _ -> acc in
  local "";;
