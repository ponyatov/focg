# var
MODULE = $(notdir $(CURDIR))
REL    = $(shell git rev-parse --short=4    HEAD)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
NOW    = $(shell date +%d%m%y)

# dirs
CWD    = $(CURDIR)

# tool
CURL   = curl -L -o
CF     = clang-format -style=file -i
OPAM   = $(HOME)/bin/opam

# src
M += $(wildcard src/*.ml*)
D += $(wildcard src/dune*) $(wildcard dune*)
S += lib/$(MODULE).ini $(wildcard lib/*.s*)
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)

CP += tmp/$(MODULE).parser.cpp tmp/$(MODULE).lexer.cpp
HP += tmp/$(MODULE).parser.hpp

# cfg
CFLAGS += -Iinc -Itmp -ggdb -O0

# all
.PHONY: all run cpp test
all: $(M) $(D) $(S)
	dune build
run: $(M) $(D) $(S)
	dune exec
cpp: bin/$(MODULE) $(S)
	$^
test: $(M) $(D) $(S)
	dune test

# format
.PHONY: format
format: tmp/format_cpp tmp/format_ml
tmp/format_cpp: $(C) $(H)
	$(CF) $? && touch $@
tmp/format_ml: $(M) $(D) $(S)
	dune build && dune fmt && touch $@

# rule
bin/$(MODULE): $(C) $(H) $(CP) $(HP) Makefile
	$(CXX) $(CFLAGS) -o $@ $(C) $(CP) $(L)
tmp/$(MODULE).lexer.cpp: src/$(MODULE).lex
	flex -o $@ $<
tmp/$(MODULE).parser.cpp: src/$(MODULE).yacc
	bison -o $@ $<

# doc
.PHONY: doc
doc:

.PHONY: doxy
doxy: .doxygen doc/DoxygenLayout.xml doc/logo.png
	rm -rf docs ; doxygen $< 1>/dev/null
doc/DoxygenLayout.xml:
	doxygen -l && mv DoxygenLayout.xml doc/
doc/logo.png: $(HOME)/icons/triangle.png
	cp $< $@

# install
.PHONY: install update ref gz
install: doc ref gz
	$(MAKE) update
update: $(OPAM)
	sudo apt update
	sudo apt install -uy `cat apt.txt`
	$(OPAM) update
	$(OPAM) install -y . --deps-only
ref:
gz:

$(OPAM):
	bash -c "sh <(curl -fsSL https://opam.ocaml.org/install.sh)"
	$(OPAM) init ; $(OPAM) switch default
	$(OPAM) install dune

# merge
MERGE += Makefile README.md apt.txt .gitignore
MERGE += .clang-format .doxygen
MERGE += .vscode bin doc lib inc src tmp ref
MERGE += $(C) $(H) $(M) $(D) $(S) .ocaml*

.PHONY: dev
dev:
	git push -v
	git checkout $@
	git pull -v
	git checkout $(USER) -- $(MERGE)
	$(MAKE) doxy ; git add -f docs

.PHONY: $(USER)
$(USER):
	git push -v
	git checkout $(USER)
	git pull -v

.PHONY: release
release:
	git tag $(NOW)-$(REL)
	git push -v --tags
	$(MAKE) $(USER)

ZIP = tmp/$(MODULE)_$(NOW)_$(REL)_$(BRANCH).zip
zip: $(ZIP)
$(ZIP):
	git archive --format zip --output $(ZIP) HEAD
