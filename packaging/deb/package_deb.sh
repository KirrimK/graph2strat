#!/bin/bash

dpkg-deb --root-owner-group --build /package/graph2strat-static
lintian /package/graph2strat-static.deb
