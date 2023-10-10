#!/bin/bash

# /packaging/scripts/build_export.sh

# from docker, is run in /home/opam/graph2strat

if ! [[ -v REPO_ROOT ]]; then
    REPO_ROOT=$PWD
    ARTIFACT_OUTPUT=/artifact
else
    ARTIFACT_OUTPUT=$REPO_ROOT/artifact
fi

cp -f $REPO_ROOT/packaging/scripts/dune_static_github.bak $REPO_ROOT/bin/dune

cd $REPO_ROOT

dune build
sudo cp $REPO_ROOT/_build/default/bin/main.exe $ARTIFACT_OUTPUT/g2s.x86_64
