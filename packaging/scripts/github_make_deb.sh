#!/bin/bash

# /packaging/scripts/github_make_deb.sh

# reference: https://www.baeldung.com/linux/create-debian-package

DEB_FOLDER=../../graph2strat-static

mkdir -p $DEB_FOLDER/DEBIAN
mkdir $DEB_FOLDER/bin
cp ../../artifact/g2s.x86_64 .$DEB_FOLDER/bin/g2s
cp ../config/control .$DEB_FOLDER/DEBIAN/control

mkdir -p $DEB_FOLDER/usr/share/doc/graph2strat-static
cp ../../LICENSE $DEB_FOLDER/usr/share/doc/graph2strat-static/copyright

cp ../files/changelog $DEB_FOLDER/usr/share/doc/graph2strat-static/changelog
gzip --best -n $DEB_FOLDER/usr/share/doc/graph2strat-static/changelog


mkdir -p $DEB_FOLDER/usr/share/man/man1
cp ../files/manpage $DEB_FOLDER/usr/share/man/man1/g2s.1
gzip --best -n $DEB_FOLDER/usr/share/man/man1/g2s.1

chmod 0755 $DEB_FOLDER/bin
chmod 0755 $DEB_FOLDER/usr
chmod 0755 $DEB_FOLDER/usr/share
chmod 0755 $DEB_FOLDER/usr/share/doc
chmod 0755 $DEB_FOLDER/usr/share/doc/graph2strat-static

chmod 0755 $DEB_FOLDER/bin/g2s

chmod 0755 $DEB_FOLDER/usr/share/man
chmod 0755 $DEB_FOLDER/usr/share/man/man1

chmod 0644 $DEB_FOLDER/usr/share/doc/graph2strat-static/*
chmod 0644 $DEB_FOLDER/usr/share/man/man1/g2s.1.gz

dpkg-deb --root-owner-group --build $DEB_FOLDER
lintian ../../graph2strat-static.deb
