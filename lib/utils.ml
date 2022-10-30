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

