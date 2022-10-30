
class Example:
    def __init__(self):
        #your code here
        """STATES_BEGIN

        #init NameOfInitState
        digraph NameOfStateMachine {
            NameOfNodeA [comment="self.on_enter/self.on_leave"] //comments allowed at EOL
            NameOfNodeB [comment="self.on_enter_"]
            NameOfNodeF [comment=""]
            {NameOfNodeC NameOfNodeD} -> NameOfNodeE [label="self.on_transition/self.guard"]
            NameOfNodeG -> NameOfNodeH [label="self.on_transition_"]
            NameOfNodeI -> NameOfNodeJ [label=""]
        }

        STATES_END"""

        # more of your code here

    """HANDLERSPL_BEGIN

    anything not matching the ignore pattern will be ignored,
    write here the name of functions you don't want to generate a placeholder for.

    IGNORE NameOfFunctionToIgnore
        
    HANDLERSPL_END"""

    # more of your code here
