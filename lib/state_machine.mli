(** Python statemachine library to be used with the generated python files *)

(** 
    statemachine library

    Python Class documentation for the library:

    ---

    Transition(name: str, destination: State\[, action: function\[, guard: function \]\]) -> Transition

    Create a transition to a State.
    Constructor arguments:
    - name: the name of the transition
    - destination: the destination State
    - guard: a function that will be called to check if the transition can be taken (True to take, False to ignore).
        (guard -> bool, by default: always returns True)

    ---

    State(name: str\[, on_enter: function\[, on_leave: function\[, transitions: list\[Transition\] \]\]\]) -> State

    Create a transition to a State.
    Constructor arguments:
    - name: the name of the state
    - on_enter: a function that will be called when the state is entered.
        param: name_previous_state: string
        (on_enter -> None, by default: does nothing)
        (on G2S start, on_enter will be called with name_previous_state = "G2SSTART")
    - on_leave: a function that will be called when the state is left.
        param: name_next_state: string
        (on_leave -> None, by default: does nothing)
    - on_loop: a function that will be called repeatedly until the state is left.
        (on_loop -> None, by default: does nothing)
    - transitions: a list of Transitions that can be taken from this state.

    ---

    StateMachine(\[init_state: State\]) -> StateMachine

    A state machine.
    Constructor arguments:
    - init_state: the initial state of the state machine.
        (State, by default: None,
        will raise an exception if not set when calling start)

*)
val lib: string
