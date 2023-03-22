(** Utilities module *)

(** The current version of the graph2strat compiler *)
val version : string

(** Removes duplicate elements from a list
    @param list the list to remove duplicates from
    @return the list without duplicates
*)
val uniq : 'a list -> 'a list

(** Reads the content of an entire file as a string 
    @param filename the name of the file to read
    @return the content of the file as a string    
*)
val read_file : string -> string

(** Reads the content of stdin in a string until EOF
    @return the content of stdin
*)
val read_stdin : unit -> string

(** Replaces the extension of a file name with a new one, and appends a suffix to the filename
    Example: path_add_name_suffix_change_extension "_suffix" "new_ext" "a.out" -> "a_suffix.new_ext"
    @param suffix the suffix to append to the filename
    @param new_ext the new extension to use
    @param path the path to the file
    @return the new path
*)
val path_add_name_suffix_change_extension : string -> string -> string -> string
