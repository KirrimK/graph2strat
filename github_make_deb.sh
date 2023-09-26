#!/bin/bash

# reference: https://www.baeldung.com/linux/create-debian-package

mkdir -p graph2strat-static/DEBIAN
mkdir graph2strat-static/bin
cp ./artifact/g2s.x86_64 graph2strat-static/bin/g2s
strip graph2strat-static/bin/g2s
cp control graph2strat-static/DEBIAN/control

mkdir -p graph2strat-static/usr/share/doc/graph2strat-static
cp LICENSE graph2strat-static/usr/share/doc/graph2strat-static/copyright

cp changelog graph2strat-static/usr/share/doc/graph2strat-static/changelog
gzip --best -n graph2strat-static/usr/share/doc/graph2strat-static/changelog


mkdir -p graph2strat-static/usr/share/man/man1
cp manpage graph2strat-static/usr/share/man/man1/g2s.1
gzip --best -n graph2strat-static/usr/share/man/man1/g2s.1

chmod 0755 graph2strat-static/bin
chmod 0755 graph2strat-static/usr
chmod 0755 graph2strat-static/usr/share
chmod 0755 graph2strat-static/usr/share/doc
chmod 0755 graph2strat-static/usr/share/doc/graph2strat-static

chmod 0755 graph2strat-static/usr/share/man
chmod 0755 graph2strat-static/usr/share/man/man1

chmod 0644 graph2strat-static/usr/share/doc/graph2strat-static/*
chmod 0644 graph2strat-static/usr/share/man/man1/g2s.1.gz

dpkg-deb --root-owner-group --build graph2strat-static
lintian graph2strat-static.deb

#rm -rf graph2strat-static