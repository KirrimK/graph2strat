#!/bin/bash

# /packaging/scripts/make_deb.sh

# in github actions runner, executed in /home/opam/graph2strat

# reference: https://www.baeldung.com/linux/create-debian-package

if ! [[ -v REPO_ROOT ]]; then
    REPO_ROOT=$PWD
fi

cp -r $REPO_ROOT/packaging/deb/ $REPO_ROOT/graph2strat-static/
mkdir $REPO_ROOT/graph2strat-static/bin
cp $REPO_ROOT/artifact/g2s.x86_64 $REPO_ROOT/graph2strat-static/bin/g2s

cp $REPO_ROOT/LICENSE $REPO_ROOT/graph2strat-static/usr/share/doc/graph2strat-static/copyright

gzip --best -n $REPO_ROOT/graph2strat-static/usr/share/doc/graph2strat-static/changelog

gzip --best -n $REPO_ROOT/graph2strat-static/usr/share/man/*/*

chmod 0755 $REPO_ROOT/graph2strat-static/*
chmod 0755 $REPO_ROOT/graph2strat-static/*/*
chmod 0755 $REPO_ROOT/graph2strat-static/*/*/*
chmod 0755 $REPO_ROOT/graph2strat-static/*/*/*/*

chmod 0644 $REPO_ROOT/graph2strat-static/usr/share/doc/graph2strat-static/*
chmod 0644 $REPO_ROOT/graph2strat-static/usr/share/man/*/*

dpkg-deb --root-owner-group --build $REPO_ROOT/graph2strat-static
lintian $REPO_ROOT/graph2strat-static.deb
