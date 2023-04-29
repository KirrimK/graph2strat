open Utils;;
open Importer;;
open State_machine;;
(* Local state memory test code *)

Random.self_init ()

(* Expected generation result: *)

let expected = Printf.sprintf "# Generated by graph2strat v%s by KirrimK@ENAC
# Report any issues on github: KirrimK/graph2strat
# Do not edit this auto-generated file manually
import typing

%s

# start of G2S machine
class G2S:
    def __init__(self, parent: typing.Any, debug=False):
        self.name = \"stm_Local_test\"
        self.parent = parent
        self.debug = debug
        self.started = False
        self.Init = State(\"Init\", on_enter=self.parent.enter, on_leave=self.parent.leave, on_loop=self.parent.loop)
        self.InitToInit = Transition(\"InitToInit\", self.Init, self.parent.guard)
        self.Init.add_transition(self.InitToInit)
        self.stm_Local_test = StateMachine(self.Init)

    def __str__(self):
        return \"G2S (\" +str(self.name) + \") machine, started = \"+ str(self.started)+ \", internals: \" + str(self.stm_Local_test)

    def start(self):
        if self.started:
            print(\"G2S (\", self.name ,\") machine is already running\")
            return
        self.stm_Local_test.start()
        self.started = True
        if self.debug:
            print(\"Started running G2S (\", self.name ,\") machine, state is\", self.stm_Local_test.state)
    
    def step(self):
        if self.debug:
            print(\">> Stepping, state is\", self.stm_Local_test.state)
        self.stm_Local_test.step()
        if self.debug:
            print(\"<< Stepped, state is\", self.stm_Local_test.state)
" version lib;;

(* Create a random folder name *)
let folder = "/tmp/testg2s__local_test__" ^ (string_of_int (Random.int 1000000))

(* Create folder *)
let _ = Sys.command ("mkdir " ^ folder)

(* Create a random file name *)
let file = "test" ^ (string_of_int (Random.int 1000000)) ^ ".dot"

(* Copy content of test_files/switch_then_loop.dot to random file *)
let _ = Sys.command ("cp ./test_files/local_test.dot " ^ folder ^ "/" ^ file)

(* Create a new graph from the random file *)
let input = read_file (folder^"/"^file)
let lexbuf = Lexing.from_string (input ^ "\n")
let stm = Parser.main Lexer.token lexbuf
let compiled = include_compile stm

let compiled_filename = path_add_name_suffix_change_extension "_g2s" "py" file

let oc = open_out (folder ^ "/" ^ compiled_filename)
let () = Printf.fprintf oc "%s" compiled
let () = close_out oc

(* Compare to expected result *)
let () = assert(expected = compiled)

(* Python execution test *)

(* Python script to run *)
let python_file = "test" ^ (string_of_int (Random.int 1000000)) ^ ".py"
let oc = open_out (folder ^ "/" ^ python_file)
let () = Printf.fprintf oc "
from %s import G2S

class Parent:
    def __init__(self):
        pass
    def enter(self, local, previous_state_name):
        local.origin = previous_state_name
        local.counter = 0
        local.destination = \"_\"
        print(\"enter\", local.origin, local.counter, local.destination)
    
    def leave(self, local, next_state_name):
        local.destination = next_state_name
        print(\"leave\", local.origin, local.counter, local.destination)
    
    def loop(self, local):
        local.counter += 1
        print(\"loop\", local.origin, local.counter, local.destination)
    
    def guard(self, local):
        print(\"guard\", local.origin, local.counter, local.destination)
        return local.counter > 3

parent = Parent()
stm = G2S(parent)
stm.start()
stm.step()
stm.step()
stm.step()
stm.step()
stm.step()
" (List.nth (String.split_on_char '.' compiled_filename) 0)
let () = close_out oc

(* Run python script *)

(* Expected stdout output *)
let expected_stdout = 
"enter G2SSTART 0 _
loop G2SSTART 1 _
guard G2SSTART 1 _
loop G2SSTART 2 _
guard G2SSTART 2 _
loop G2SSTART 3 _
guard G2SSTART 3 _
loop G2SSTART 4 _
guard G2SSTART 4 _
leave G2SSTART 4 Init
enter Init 0 _
loop Init 1 _
guard Init 1 _
"

(* Run python script *)
let _ = Sys.command ("python3 " ^ folder ^ "/" ^ python_file ^ " > " ^ folder ^ "/stdout.txt")

(* Read stdout output *)
let stdout = read_file (folder ^ "/stdout.txt")

(* Compare to expected stdout output *)
let () = assert(expected_stdout = stdout)

(* Remove folder *)
let _ = Sys.command ("rm -rf " ^ folder)

(* End of test code *)