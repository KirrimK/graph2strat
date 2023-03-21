%{
  open Compiler
%}

%token <string> IDENTIFIER

%token DIGRAPH
%token INIT
%token COMMENT
%token LABEL

%token ARROW_LEFT

%token LCBR
%token RCBR

%token LBR
%token RBR

%token EQUAL
%token EOF
(* Priority of operators *)

(* *)

%start<Compiler.statemachine> main

%%

main:
  DIGRAPH name = IDENTIFIER LCBR st_ls = statement_list RCBR EOF {StateMachine(None, "stm_"^name, st_ls)}
| DIGRAPH name = IDENTIFIER LCBR RCBR EOF {StateMachine(None, "stm_"^name, [])}
| INIT init = IDENTIFIER DIGRAPH name = IDENTIFIER LCBR st_ls = statement_list RCBR EOF {StateMachine((Some init), "stm_"^name, st_ls)}
| INIT init = IDENTIFIER DIGRAPH name = IDENTIFIER LCBR RCBR EOF {StateMachine((Some init), "stm_"^name, [])}

statement_list:
  st = statement {[st]}
| st = statement st_ls = statement_list {st::st_ls}

statement:
  nd = node_statement {nd}
| edge = edge_statement {edge}

node_statement:
  st_id = IDENTIFIER LBR COMMENT EQUAL on_enter_and_on_leave = IDENTIFIER RBR 
    {State(st_id, on_enter_and_on_leave)}

edge_statement:
  sta_id = IDENTIFIER ARROW_LEFT stb_id = IDENTIFIER LBR LABEL EQUAL guard_and_on_transition = IDENTIFIER RBR
    {Transition([sta_id], stb_id, guard_and_on_transition)}
| LCBR id_ls = id_list RCBR ARROW_LEFT stb_id = IDENTIFIER LBR LABEL EQUAL guard_and_on_transition = IDENTIFIER RBR
    {Transition(id_ls, stb_id, guard_and_on_transition)}

id_list:
  id = IDENTIFIER {[id]}
| id = IDENTIFIER id_ls = id_list {id::id_ls}