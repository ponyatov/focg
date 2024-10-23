# tools
CURL   = curl -L -o
CF     = clang-format -style=file -i
OPAM   = /home/dponyatov/bin/opam

# src
M += $(wildcard src/*.ml*)
D += $(wildcard src/dune*) $(wildcard dune*)
S += lib/$(MODULE).ini $(wildcard lib/*.s*)
C += $(wildcard src/*.c*)
H += $(wildcard inc/*.h*)

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
	dune build && dune fmt

# rule
bin/$(MODULE): $(C) $(H) $(CP) $(HP) Makefile
	$(CXX) $(CFLAGS) -o $@ $(C) $(CP) $(L)

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
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
ref:
gz:

$(OPAM):
	bash -c "sh <(curl -fsSL https://opam.ocaml.org/install.sh)"
	opam init
	opam install dune
