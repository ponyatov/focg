# tools
CURL = curl -L -o
CF   = clang-format -style=file -i
OPAM = /home/dponyatov/bin/opam

# doc
.PHONY: doc
doc:

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
