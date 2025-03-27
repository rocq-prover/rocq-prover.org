.DEFAULT_GOAL := all
DOC_PATH=$(shell pwd)/rocq-doc/
GIT_HEAD=$(shell git rev-parse HEAD)
GIT_DIRTY=$(shell git diff --quiet HEAD || echo "-dirty")
GIT_COMMIT=${GIT_HEAD}${GIT_DIRTY}
GIT_BRANCH=$(shell git branch --show-current)

export GIT_COMMIT
export GIT_BRANCH
export DOC_PATH

.PHONY: all
all:
	opam exec -- dune build --root .

.PHONY: show-config
show-config:
	@echo "DOC_PATH="${DOC_PATH}
	@echo "GIT_COMMIT="${GIT_COMMIT}
	@echo "GIT_BRANCH="${GIT_BRANCH}

.PHONY: deps
deps: create_switch ## Install development dependencies
	opam install -y ocamlformat=0.26.2 ocaml-lsp-server
	opam install -y --deps-only --with-test --with-doc .

.PHONY: create_switch
create_switch: ## Create switch and pinned opam repo
	opam switch create . 5.2.0 --no-install --repos pin=git+https://github.com/ocaml/opam-repository#c45f5bab71d3589f41f9603daca5acad14df0ab0

.PHONY: switch
switch: deps ## Create an opam switch and install development dependencies

.PHONY: lock
lock: ## Generate a lock file
	opam lock -y .

.PHONY: build
build: ## Build the project, including non installable libraries and executables
	opam exec -- dune build --root .

.PHONY: playground
playground:
	make build -C playground

.PHONY: install
install: all ## Install the packages on the system
	opam exec -- dune install --root .

.PHONY: local-doc
local-doc:
	if [ -d rocq-doc ]; then cd rocq-doc && git pull; \
	else git clone --depth 1 https://github.com/rocq-prover/doc.git rocq-doc; fi

.PHONY: update-local-doc
update-local-doc:
	@if [ -d rocq-doc ]; then cd rocq-doc && git pull; \
	else echo "No local doc copy, use \"make local-doc\" to get a local copy (~ 8 GB)"; fi

.PHONY: start
start: all update-local-doc ## Run the produced executable
	opam exec -- dune exec src/rocqproverorg_web/bin/main.exe

.PHONY: test
test: ## Run the unit tests
	opam exec -- dune build --root . @runtest

.PHONY: clean
clean: ## Clean build artifacts and other generated files
	opam exec -- dune clean --root .

.PHONY: doc
doc: ## Generate odoc documentation
	opam exec -- dune build --root . @doc

.PHONY: fmt
fmt: ## Format the codebase with ocamlformat
	opam exec -- dune build --root . --auto-promote @fmt
	
.PHONY: watch
watch: update-local-doc ## Watch for the filesystem and rebuild on every change
	opam exec -- dune build @run -w --force --no-buffer

.PHONY: utop
utop: ## Run a REPL and link with the project's libraries
	opam exec -- dune utop --root . . -- -implicit-bindings

.PHONY: scrape
scrape: ## Generate the po files
	opam exec -- dune exec --root . tool/ood-gen/bin/scrape.exe planet
	opam exec -- dune exec --root . tool/ood-gen/bin/scrape.exe video

.PHONY: docker
docker: ## Generate docker container
	docker build --build-arg GIT_COMMIT=${GIT_COMMIT} --build-arg GIT_BRANCH=${GIT_BRANCH} -f Dockerfile . -t rocqproverorg:latest

.PHONY: linkcheck
linkcheck:
	opam exec -- dune exec --root . olinkcheck md data
