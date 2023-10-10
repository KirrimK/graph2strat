#!/bin/sh

# /packaging/scripts/build_export.sh

cp -f ./dune_static_github.bak ../../bin/dune

cd ../..

dune build
sudo cp _build/default/bin/main.exe /statbuild/g2s.x86_64
