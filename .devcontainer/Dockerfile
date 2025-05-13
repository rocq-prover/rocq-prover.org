FROM ocaml/opam:debian-ocaml-5.2

# Branch freeze was opam-repo HEAD at the time of commit
RUN cd ~/opam-repository && git checkout -b freeze dbc9ec7b83bac3673185542221a571372b6abb35 && opam update

# Dev tools
RUN opam install -y dune-release merlin ocamlformat=0.26.2 utop ocaml-lsp-server

# Deps
RUN sudo apt update && sudo apt install -y pkg-config libev-dev libgmp-dev libonig-dev libssl-dev

RUN opam install -y --deps-only --with-test --with-doc .


