(lang dune 2.9)
(using menhir 2.1)

(name graph2strat)

(version 1.6.3)

(generate_opam_files true)

(source
 (github KirrimK/graph2strat))

(authors "Rémy B")

(maintainers "Rémy B")

(license MIT)

(documentation https://kirrimk.github.io/graph2strat/)

(package
 (name graph2strat)
 (synopsis "A tool designed to make development of statemachines for robot strategy easier")
 (description "")
 (depends
    ocaml
    dune
    (menhir (>= 2.1))
    (dune-build-info (>= 3.5))
    (ppx_getenv (>= 2.1)))
 (tags
  (python dot statemachine)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
