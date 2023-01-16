# importations

class TestTemplating():

    # attributs de classe

    def __init__(self):
        # initialisation des attributs, super(), etc...

        # insertion des états et transitions
        """STATES_FILE:./test.dot"""

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

    IGNORE ma_garde
    IGNORE on_leave
    IGNORE on_enter
    
    HANDLERSPL_END"""

def main(args=None):
    strat = TestTemplating()
    # autre code

if __name__ == '__main__':
    main()
