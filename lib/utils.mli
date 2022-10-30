(** Utilities module *)

(** The current version of the graph2strat compiler *)
val version : string

(** Removes duplicate elements from a list
    @param list the list to remove duplicates from
    @return the list without duplicates
*)
val uniq : 'a list -> 'a list
