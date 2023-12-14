project_name = yojson

DUNE = opam exec -- dune

.PHONY: all
all:
	@dune build @install

.PHONY: run-examples
run-examples:
	dune exec examples/filtering.exe < examples/filtering.json

.PHONY: install
install:
	@dune install

.PHONY: mel-install
mel-install: ## Install development dependencies
	$(DUNE) build $(project_name).opam
	opam update # make sure that opam has the latest information about published libraries in the opam repository https://opam.ocaml.org/packages/
	opam install -y . --deps-only --with-test # install the Melange and OCaml dependencies

.PHONY: create-switch
create-switch:
	opam switch create . -y --deps-only

.PHONY: init
init: create-switch mel-install

.PHONY: build
build:
	$(DUNE) build

.PHONY: watch
watch:
	$(DUNE) build --watch

.PHONY: uninstall
uninstall:
	@dune uninstall

.PHONY: bench
bench:
	@dune build --display=quiet @bench-generic-sexp --force
	@dune build --display=quiet @bench-buffer-sexp --force

.PHONY: bench-local
bench-local:
	@dune build @bench --force

.PHONY: clean
clean:
	@dune clean

.PHONY: test
test:
	@dune runtest --force

