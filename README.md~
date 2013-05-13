# Mongo.ml

**Mongo.ml** is an OCaml driver for MongoDB. 

It supplies a series of APIs which can be used to communicate with MongoDB, i.e., **Insert**, **Update**, **Delete** and **Query/Find**.

Here is the [API docs]().

### Prequisite

This driver uses **unix** and external [Bson.ml](http://massd.github.io/bson/) modules.

For the conveniences, **bson.ml** and **bson.mli** are included in the **src** folder with **Mongo.ml**

Here is the [API doc](http://massd.github.io/bson/doc/Bson.html) for **Bson.ml**

### How to use it

**Mongo** and **MongoAdmin** are the two modules for high level usage.

**Mongo** is a MongoDB client for general purpose. It can be used to operate normal bson documents on MongoDB.

**MongoAdmin** is a special MongoDB client for accessing admin level of MongoDB commands, such as **list databases**, etc. Please refer to [MongoDB commands](http://docs.mongodb.org/manual/reference/command/).

The usages of these two modules are similar:

1. **Mongo.create** a Mongo with ip, port, db\_name, and collection\_name (MongoAdmin does not need db\_name or collection\_name)
2. Depending on the request type, create the Bson document using **Bson.ml**
3. **Mongo.insert** / **Mongo.update** / **Mongo.delete** / **Mongo.find** / **Mongo.get**more** / **Mongo.kill_cursors**
4. Only **Mongo.find** and **Mongo.get**more** will wait for a **MongoReply**. Others will finish immediately.
5. **Mongo.destory** the Mongo to release the resources.

### Sample usage

Please refer to **test/test**mongo.ml** for a taste of usage.

	ocamlbuild -use-ocamlfind -I src test/test_mongo.native
	./test_mongo.native

### Extend the driver

Comparing to MongoDB's official drivers, **this OCaml driver is not that complete.**

This driver can be used only for **essential** operations on MongoDB, particularly with all default options/configurations.

I am slowly extend this driver and **experienced OCaml/MongoDB developers are welcomed to join**.

I explain briefly about the source code structure as follows:

**MongoOperation** defines all operations allowed by MongoDB.

**MongoHeader** defines the header that is used in MongoDB messages. It includes encoding / decoding the MongoDB messages. When constructing a **MongoRequest**, encoding is used; when constructing a **MongoReply** from the message sent by MongoDB, decoding is used.

**MongoRequest** create the message bytes (string) for all requests. The output string can be used to **MongoSend** to send to MongoDB socket. Every function inside has full parameters according to [MongoDB wire protocol](http://docs.mongodb.org/meta-driver/latest/legacy/mongodb-wire-protocol/).

**MongoSend** takes a **unix file**descr** and a **string** and send the string to the file_descr. It uses **unix**.

**MongoReply** is the type that contains the reply MongoDB.

****Mongo** and **MongoAdmin** are desired to be extended. They contain the real client-faced high level APIs.**

### Misco

The current version is **0.66.0**.













