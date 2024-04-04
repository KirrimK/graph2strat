#!/bin/bash

sudo mv /home/opam/graph2strat/bin/dune /home/opam/graph2strat/bin/dune.bak
sudo cp packaging/dune_static_github.bak /home/opam/graph2strat/bin/dune
sudo dune build
sudo mv /home/opam/graph2strat/bin/dune.bak /home/opam/graph2strat/bin/dune
sudo strip _build/default/bin/main.exe
