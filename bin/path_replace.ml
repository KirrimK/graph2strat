(* Path_replace.ml *)

(** Replaces the extension of a file name with a new one, and appends a suffix to the filename
    Example: path_add_name_suffix_change_extension "_suffix" "new_ext" "a.out" -> "a_suffix.new_ext"
*)
let path_add_name_suffix_change_extension = fun suffix ext path ->
  let path_split = String.split_on_char '.' path in
  let path_array = Array.of_list path_split in
  let path_array_length = Array.length path_array in
  let () = path_array.(path_array_length - 2) <- path_array.(path_array_length - 2) ^ suffix in
  let () = path_array.(path_array_length - 1) <- ext in
  String.concat "." (Array.to_list path_array)
