# importations

class TestTemplating():

    # attributs de classe

    def __init__(self):
        # initialisation des attributs, super(), etc...

        # insertion des états et transitions
        """STATES_BEGIN

        //init Init
        digraph test {
            Init [comment="on_enter/on_leave"]
            Outhome [comment="on_enter_/on_leave_"]
            {Init Outhome} -> End [label="on_transition/guard"]
        }
        
        STATES_END"""

        # autre code d'__init__
        pass

    # définitions de méthodes
    
    # définitions des gardes et transitions à ne pas écraser
    def ma_garde(self):
        return False

    def on_leave(self):
        pass

    # insertion des placeholders de gardes, actions de transitions
    """HANDLERSPL_BEGIN

    NO_HANDLERPL ma_garde
    NO_HANDLERPL on_leave
    
    HANDLERSPL_END"""

def main(args=None):
    strat = TestTemplating()
    # autre code

if __name__ == '__main__':
    main()
