FROM docker.io/ocaml/opam:alpine-ocaml-4.08

# Website used as ref for static OCaml build process
# http://rgrinberg.com/posts/static-binaries-tutorial/

VOLUME /home/opam/graph2strat

COPY ./graph2strat.opam /home/opam/graph2strat.opam

RUN mkdir -p /home/opam/graph2strat

RUN opam install -y --deps-only /home/opam/graph2strat.opam

RUN sudo apk add binutils

WORKDIR /home/opam/graph2strat

RUN sudo chown -R opam /home/opam/graph2strat

COPY ./packaging/build_static.sh /home/opam/build_static.sh

RUN sudo chmod +x /home/opam/build_static.sh

CMD ["bash", "-c", "/home/opam/build_static.sh"]
