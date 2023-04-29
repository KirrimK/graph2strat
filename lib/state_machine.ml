let lib =
"# Statemachine library preincluded in G2S file
from copy import copy

class Object(object):
    pass

class Transition:
    \"\"\"
    Transition(name: str, destination: State[, guard: function ]) -> Transition

    Create a transition to a State.
    Constructor arguments:
    - name: the name of the transition
    - destination: the destination State
    - guard: a function that will be called to check if the transition can be taken (True to take, False to ignore).
        param: local: Object
        (guard -> bool, by default: always returns True)
    \"\"\"
    def accept_by_default(self, local):
        print(f\"{self.name}: accept_by_default\")
        return True

    def __init__(self, name, destination, guard = None):
        self.name = name
        self.destination = destination
        if guard is None:
            self.guard = self.accept_by_default
        else:
            self.guard = guard

    def __str__(self):
        return f\"Transition({self.name})\"

class State:
    \"\"\"
    State(name: str[, on_enter: function[, on_leave: function[, on_loop: function[, transitions: list[Transition] ]]]]) -> State

    Create a transition to a State.
    Constructor arguments:
    - name: the name of the state
    - on_enter: a function that will be called when the state is entered.
        param: local: Object
        param: name_previous_state: string
        (on_enter -> None, by default: does nothing)
        (on G2S start, on_enter will be called with name_previous_state = \"G2SSTART\")
    - on_leave: a function that will be called when the state is left.
        param: local: Object
        param: name_next_state: string
        (on_leave -> None, by default: does nothing)
    - on_loop: a function that will be called repeatedly until the state is left.
        param: local: Object
        (on_loop -> None, by default: does nothing)
    - transitions: a list of Transitions that can be taken from this state.
    \"\"\"
    def on_enter_default(self, local, name_previous_state):
        print(f\"{self.name}: on_enter_default from\", name_previous_state)
    def on_leave_default(self, local, name_next_state):
        print(f\"{self.name}: on_leave_default to\", name_next_state)
    def on_loop_default(self, local):
        print(f\"{self.name}: on_loop_default\")

    def __init__(self, name, on_enter = None, on_leave = None, on_loop = None, transitions = []):
        self.name = name
        if on_enter is None:
            self.on_enter = self.on_enter_default
        else:
            self.on_enter = on_enter

        if on_leave is None:
            self.on_leave = self.on_leave_default
        else:
            self.on_leave = on_leave

        if on_loop is None:
            self.on_loop = self.on_loop_default
        else:
            self.on_loop = on_loop

        self.transitions = transitions.copy()

    def add_transition(self, transition):
        self.transitions.append(transition)

    def check_transitions(self, local):
        for transition in self.transitions:
            if transition.guard(local):
                self.on_leave(local, transition.destination.name)
                return transition.destination
        return None

    def __str__(self):
        str_trs = \"\"
        for t in self.transitions:
            str_trs += str(t)+\" \"
        return f\"State({self.name}, [{str_trs}])\"

class StateMachine:
    \"\"\"
    StateMachine([init_state: State]) -> StateMachine

    A state machine.
    Constructor arguments:
    - init_state: the initial state of the state machine.
        (State, by default: None,
        will raise an exception if not set when calling start)
    \"\"\"
    def __init__(self, init_state = None):
        self.init_state = init_state
        self.state = init_state
        self.is_started = False
    
    def start(self):
        if self.state is None:
            raise Exception(\"No initial state\")
        if not self.is_started:
            self.current_local = copy(Object())
            self.state.on_enter(self.current_local, \"G2SSTART\")
            self.is_started = True
    
    def step(self):
        if self.state is not None and self.is_started:
            self.state.on_loop(self.current_local)
            new_state = self.state.check_transitions(self.current_local)
            if new_state is not None:
                self.current_local = copy(Object())
                new_state.on_enter(self.current_local, self.state.name)
                self.state = new_state
    
    def __str__(self):
        return f\"StateMachine({str(self.state)})\""
