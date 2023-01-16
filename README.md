# Graph2Strat compiler

A program used to compile dot graph snippets into state machine directly used within python code.

Originally a tool for the ENACRobotique robotics club.

[![Run on Repl.it](https://replit.com/badge/github/KirrimK/graph2strat)](https://replit.com/@KirrimK/graph2strat)

## Installation

(Linux only)
Install ocaml and opam from your package manager.
Then using opam, configure an additionnal repo:
```bash
opam repo add KirrimK https://github.com/KirrimK/opam-repo.git
```
Then install the compiler:
```bash
opam update
opam install graph2strat
```

## Build from source

Clone this repo, then using opam, install the required dependencies: dune, menhir, re2.
Then run `dune build` to build the compiler.
Run the build using `dune exec graph2stratcompiler <file>`.

OCaml code documentation is at [https://kirrimk.github.io/graph2strat/](https://kirrimk.github.io/graph2strat/) and can be generated using `dune build @doc`.
Automated tests (once added) can be run using `dune runtest`.

## Usage

If you installed the compiler using opam, you can run it using `graph2stratcompiler <filename>.py`.
This will generate a file named `<filename>_gen.py` containing the completed python template in the current folder, and a file in the same folder called `statemachine.py` containing a copy of the custom state machine library to be used with this compiler.

You can also specify the output file using the '-o' option, and the statemachine library will be added in the same folder.

If no file is specified, the compiler will read from stdin and write to stdout. To generate only the library, use the `--lib` flag to get a copy of the library on stdout.

It will take files using this format:
```python

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

```

The blocks will be replaced by compiled code, matching the indent levels of the template blocks. The order of the blocks is not important.

The following code will be generated:

```python

class Example:
    def __init__(self):
        #your code here
        # [graph2strat generated states and transitions]
        NameOfNodeF = State("NameOfNodeF")
        NameOfNodeB = State("NameOfNodeB", self.on_enter_)
        NameOfNodeA = State("NameOfNodeA", self.on_enter, self.on_leave)
        NameOfNodeI = State("NameOfNodeI")
        NameOfNodeJ = State("NameOfNodeJ")
        NameOfNodeG = State("NameOfNodeG")
        NameOfNodeH = State("NameOfNodeH")
        NameOfNodeD = State("NameOfNodeD")
        NameOfNodeC = State("NameOfNodeC")
        NameOfNodeE = State("NameOfNodeE")
        tr98800212 = Transition("tr98800212", NameOfNodeE, self.on_transition, self.guard)
        NameOfNodeC.add_transition(tr98800212)
        NameOfNodeD.add_transition(tr98800212)
        NameOfNodeGToNameOfNodeH = Transition("NameOfNodeGToNameOfNodeH", NameOfNodeH, self.on_transition_)
        NameOfNodeG.add_transition(NameOfNodeGToNameOfNodeH)
        NameOfNodeIToNameOfNodeJ = Transition("NameOfNodeIToNameOfNodeJ", NameOfNodeJ)
        NameOfNodeI.add_transition("NameOfNodeIToNameOfNodeJ")
        self.NameOfStateMachine = StateMachine(NameOfInitState)
        # [end of generated content]

        # more of your code here

    # [graph2strat generated placeholder handlers]
    def on_transition_(self):
        pass

    def guard(self):
        return True

    def on_transition(self):
        pass

    def on_enter_(self):
        pass

    def on_leave(self):
        pass

    def on_enter(self):
        pass

    # [end of generated content]

    # more of your code here
```


## Bugs/limits:

For now, the compiler only supports a single state machine per file, and only one placeholder block per file.
For now, the compiler is not very configurable, and expects the codes to be in a class. More configuration options will be available later
Don't declare nodes with the same name but different caracteristics.
Extensive testing hasn't been done yet, check that the output seems to correspond to the input.
If a bug is found, please file an issue on the github page.

## Project TODOs

- improve configuration options
- improve error messages
- improve testing
