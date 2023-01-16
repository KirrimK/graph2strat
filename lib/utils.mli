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
