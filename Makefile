SETUP = ocaml setup.ml

build: setup.data
	$(SETUP) -build $(BUILDFLAGS)

lwt: setup.data.lwt
	$(SETUP) -build $(BUILDFLAGS)

test: setup.data build
	ocamlbuild -use-ocamlfind -I src test/test_mongo.native

doc: setup.data build
	ocaml setup.ml -doc
	cp -r _build/src/mongo.docdir doc
	cp -r _build/lwt/mongo_lwt.docdir doc_lwt

all:
	$(SETUP) -all $(ALLFLAGS)

install: setup.data
	$(SETUP) -install $(INSTALLFLAGS)

uninstall: setup.data
	$(SETUP) -uninstall $(UNINSTALLFLAGS)

reinstall: setup.data
	$(SETUP) -reinstall $(REINSTALLFLAGS)

clean:
	$(SETUP) -clean $(CLEANFLAGS)

distclean:
	$(SETUP) -distclean $(DISTCLEANFLAGS)

setup.data:
	$(SETUP) -configure $(CONFIGUREFLAGS)

setup.data.lwt:
	$(SETUP) -configure --enable-lwt $(CONFIGUREFLAGS)

.PHONY: build doc test all install uninstall reinstall clean distclean configure
