cp -f ./bin/dune_static_github.bak ./bin/dune

dune build
sudo cp _build/default/bin/main.exe /statbuild/g2s.x86_64
