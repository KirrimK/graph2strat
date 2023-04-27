open Compiler;;
open State_machine;;
open Utils;;

let include_compile = fun stm ->
  let StateMachine(_, name, _) = stm in
  let graph_py_instrs = graph_to_python 8 stm in
  Printf.sprintf "# Generated by graph2strat v%s by KirrimK@ENAC
# Report any issues on github: KirrimK/graph2strat
# Do not edit this auto-generated file manually
import typing

%s

# start of G2S machine
class G2S:
    def __init__(self, parent: typing.Any, debug=False):
        self.name = \"%s\"
        self.parent = parent
        self.debug = debug
        self.started = False
%s

    def __str__(self):
        return \"G2S (\" +str(self.name) + \") machine, started = \"+ str(self.started)+ \", internals: \" + str(self.%s)

    def start(self):
        if self.started:
            print(\"G2S (\", self.name ,\") machine is already running\")
            return
        self.%s.start()
        self.started = True
        if self.debug:
            print(\"Started running G2S (\", self.name ,\") machine, state is\", self.%s.state)
    
    def step(self):
        if self.debug:
            print(\">> Stepping, state is\", self.%s.state)
        self.%s.step()
        if self.debug:
            print(\"<< Stepped, state is\", self.%s.state)
" version lib name graph_py_instrs name name name name name name
