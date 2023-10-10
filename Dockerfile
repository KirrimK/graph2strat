FROM docker.io/ocaml/opam:alpine-ocaml-4.08

# Website used as ref for static OCaml build process
# http://rgrinberg.com/posts/static-binaries-tutorial/

COPY . /home/opam/graph2strat/

RUN sudo chown -R opam /home/opam/graph2strat

WORKDIR /home/opam/graph2strat

RUN opam install -y . --deps-only

RUN sudo chmod +x ./packaging/scripts/build_export.sh

CMD ["sh", "-c", "./packaging/scripts/build_export.sh"]
