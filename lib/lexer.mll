{
    open Parser
    exception Error of string

    let pe = fun a b ->
      a := !a + b
    
    let colnum = ref 0
    let rownum = ref 0
}

let digit = ['0'-'9']
let lower = ['a'-'z']
let upper = ['A'-'Z']
let letter = lower | upper
let other = ['_' ':']

let id = (letter| other) (letter | other | digit)+

rule token = parse
    "#init" { pe colnum 5; INIT }
  | "digraph" { pe colnum 7; DIGRAPH }
  | "comment" { pe colnum 7; COMMENT }
  | "label" { pe colnum 5; LABEL }
  | "->" { pe colnum 2; ARROW_LEFT }
  | '{' { pe colnum 1; LCBR }
  | '}' { pe colnum 1; RCBR }
  | '[' { pe colnum 1; LBR }
  | ']' { pe colnum 1; RBR }
  | '=' { pe colnum 1; EQUAL }
  | id as i { pe colnum (String.length i); IDENTIFIER i}
  | '\"' ([^'\"']* as str) '\"' { pe colnum ((String.length str)+2); IDENTIFIER (str) }
  | "//" ([^'\r' '\n']* as comment) { pe colnum ((String.length comment)+2); token lexbuf } (* Comments *)
  | [' ' '\t'] { pe colnum 2; token lexbuf }
  | ['\n'] {pe rownum 1; colnum := 0; token lexbuf }
  | eof { EOF }
  | _ as c { raise (Error (Printf.sprintf "Line %d, column %d: unexpected character: %c.\n" !rownum !colnum c)) }
