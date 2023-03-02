(** Compiler module *)

(** Either a State or a Transition of the Statemachine*)
type statement =
    State of string * string (** name * on_enter/on_leave *)
  | Transition of string list * string * string (** in_states * out_state * on_transition/guard *)

(** The Statemachine with its name, optionnal entrypoint, states and transitions *)
type statemachine = StateMachine of string option * string * statement list (** init_state_option * name * statements *)

(** Statement to string, for debug purposes 
    @param statement the statement to convert
    @return the string representation of the statement
*)
val st_str : statement -> string

(** Statemachine to string, for debug purposes 
    @param statemachine the statemachine to convert
    @return the string representation of the statemachine
*)
val stm_str : statemachine -> string

(** Converts a statement to python code
    @param spacing the spacing to use for the code
    @param statement the statement to convert
    @return the python code for the statement
*)
val statement_to_python : int -> statement -> string

(** Converts a statemachine to python code
    @param spacing the spacing to use for the code
    @param statemachine the statemachine to convert
    @return the python code for the statemachine
*)
val graph_to_python : int -> statemachine -> string

(** Find functions names (enter/leave/on_transition/guard) mentionned in the statemachine 
    @param statemachine the statemachine to parse
    @return a list of (function name * is_guard)
*)
val find_functions : statemachine -> (string * bool) list

val include_compile: statemachine -> string
