{
    open Parser
    exception Error of string
}

let digit = ['0'-'9']
let lower = ['a'-'z']
let upper = ['A'-'Z']
let letter = lower | upper
let other = ['_' ':']

let id = (letter| other) (letter | other | digit)+

rule token = parse
    "//init" { INIT }
  | "digraph" { DIGRAPH }
  | "comment" { COMMENT }
  | "label" { LABEL }
  | "->" { ARROW_LEFT }
  | '{' { LCBR }
  | '}' { RCBR }
  | '[' { LBR }
  | ']' { RBR }
  | '=' { EQUAL }
  | id as i { IDENTIFIER i}
  | '\"' ([^'\"']* as str) '\"' { IDENTIFIER (str) }
  | "//"[^'\r' '\n']* {token lexbuf} (* Comments *)
  | [' ' '\t' '\n']+ {token lexbuf}
  | eof { EOF }
  | _ as c { raise (Error (Printf.sprintf "At offset %d: unexpected character: %c.\n"
  (Lexing.lexeme_start lexbuf) c)) }