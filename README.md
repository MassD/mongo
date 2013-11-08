# Mongo.ml

**Mongo.ml** is an OCaml driver for MongoDB.

It supplies a series of APIs which can be used to communicate with MongoDB, i.e., **Insert**, **Update**, **Delete** and **Query / Find**.

Here is the [Mongo.ml API docs](http://massd.github.io/mongo/doc/).

### Prequisite

This driver uses **unix** and external [Bson.ml](http://massd.github.io/bson/) modules.

Here is the [Bson.ml API doc](http://massd.github.io/bson/doc/Bson.html).

***

### How to use it

**Mongo** and **MongoAdmin** are the two modules for high level usage.

**Mongo** is a MongoDB client for general purpose. It can be used to operate normal bson documents on MongoDB.

**MongoAdmin** is a special MongoDB client for accessing admin level of MongoDB commands, such as _list databases_, etc. Please refer to [MongoDB commands](http://docs.mongodb.org/manual/reference/command/).

The usages of these two modules are similar:

1. **Mongo.create** a Mongo with ip, port, db\_name, and collection\_name (MongoAdmin does not need db\_name or collection\_name)
2. Depending on the request type, create the Bson document using **Bson.ml**
3. **Mongo.insert** / **Mongo.update** / **Mongo.delete** / **Mongo.find** / **Mongo.get_more** / **Mongo.kill_cursors**
4. Only **Mongo.find** and **Mongo.get_more** will wait for a **MongoReply**. Others will finish immediately.
5. **Mongo.destory** the Mongo to release the resources.

***

### Sample usage

Please refer to **test/test_mongo.ml** for a taste of usage.

	ocamlbuild -use-ocamlfind -I src test/test_mongo.native
	./test_mongo.native

***

### Extend the driver

Comparing to MongoDB's official drivers, **this OCaml driver is not that complete.**

This driver can be used only for **essential** operations on MongoDB, particularly with all default options/configurations.

I am slowly extend this driver and **experienced OCaml/MongoDB developers are welcomed to join**.

***

### The source code

**MongoOperation** defines all operations allowed by MongoDB.

**MongoHeader** defines the header that is used in MongoDB messages. It includes encoding / decoding the MongoDB messages. When constructing a **MongoRequest**, encoding is used; when constructing a **MongoReply** from the message sent by MongoDB, decoding is used.

**MongoRequest** create the message bytes (string) for all requests. The output string can be used to **MongoSend** to send to MongoDB socket. Every function inside has full parameters according to [MongoDB wire protocol](http://docs.mongodb.org/meta-driver/latest/legacy/mongodb-wire-protocol/).

**MongoSend** takes a **unix file_descr** and a **string** and send the string to the file_descr. It uses **unix**.

**MongoReply** is the type that contains the reply MongoDB.

**Mongo** and **MongoAdmin** are the client-faced interfaces. They are the first places to be extended.

***

### Misc

The current version is **0.67.1**.

### OPAM
Since version 0.67.0, bson.ml and mongo.ml are package in opam.
To install with opam:
`opam repo add mongo-package git@github.com:MassD/mongo.git`
Then: `opam install mongo`
