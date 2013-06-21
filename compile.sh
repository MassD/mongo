ocamlbuild -use-ocamlfind src/mongo.native
ocamlbuild -use-ocamlfind src/mongo.byte

ocamlbuild -use-ocamlfind src/mongoReply.native
ocamlbuild -use-ocamlfind src/mongoReply.byte

ocamlbuild -use-ocamlfind src/mongoAdmin.native
ocamlbuild -use-ocamlfind src/mongoAdmin.byte

ocamlbuild -use-ocamlfind src/mongoSend.native
ocamlbuild -use-ocamlfind src/mongoSend.byte

ocamlbuild -use-ocamlfind src/mongoRequest.native
ocamlbuild -use-ocamlfind src/mongoRequest.byte

ocamlbuild -use-ocamlfind src/mongoOperation.native
ocamlbuild -use-ocamlfind src/mongoOperation.byte

ocamlbuild -use-ocamlfind src/mongoUtils.native
ocamlbuild -use-ocamlfind src/mongoUtils.byte
