# Mongo.ml

**Mongo.ml** is an OCaml driver for MongoDB. 

It supplies a series of APIs which can be used to communicate with MongoDB, i.e., **Insert**, **Update**, **Delete** and **Query/Find**.

Here is the [API docs]().

### Prequisite

This driver uses _unix_ and external [Bson.ml](http://massd.github.io/bson/) modules.

For the conveniences, _bson.ml_ and _bson.mli_ are included in the _src_ folder with _Mongo.ml_

Here is the [API doc](http://massd.github.io/bson/doc/Bson.html) for _Bson.ml_

### How to use it

**Mongo** and **MongoAdmin** are the two modules for high level usage.

**Mongo** is a MongoDB client for general purpose. It can be used to operate normal bson documents on MongoDB.

**MongoAdmin** is a special MongoDB client for accessing admin level of MongoDB commands, such as _list databases_, etc. Please refer to [MongoDB commands](http://docs.mongodb.org/manual/reference/command/).

The usages of these two modules are similar:

1. _Mongo.create_ a Mongo with ip, port, db\_name, and collection\_name (MongoAdmin does not need db\_name or collection\_name)
2. Depending on the request type, create the Bson document using _Bson.ml_
3. _Mongo.insert_ / _Mongo.update_ / _Mongo.delete_ / _Mongo.find_ / _Mongo.get_more_ / _Mongo.kill_cursors_
4. Only _Mongo.find_ and _Mongo.get_more_ will wait for a _MongoReply_. Others will finish immediately.
5. _Mongo.destory_ the Mongo to release the resources.

### Sample usage

Please refer to _test/test_mongo.ml_ for a taste of usage.

	ocamlbuild -use-ocamlfind -I src test/test_mongo.native
	./test_mongo.native

### Extend the driver

Comparing to MongoDB's official drivers, **this OCaml driver is not that complete.**

This driver can be used only for **essential** operations on MongoDB, particularly with all default options/configurations.

I am slowly extend this driver and **experienced OCaml/MongoDB developers are welcomed to join**.

I explain briefly about the source code structure as follows:

_MongoOperation_ defines all operations allowed by MongoDB.

_MongoHeader_ defines the header that is used in MongoDB messages. It includes encoding / decoding the MongoDB messages. When constructing a _MongoRequest_, encoding is used; when constructing a _MongoReply_ from the message sent by MongoDB, decoding is used.

_MongoRequest_ create the message bytes (string) for all requests. The output string can be used to _MongoSend_ to send to MongoDB socket. Every function inside has full parameters according to [MongoDB wire protocol](http://docs.mongodb.org/meta-driver/latest/legacy/mongodb-wire-protocol/).

_MongoSend_ takes a _unix file_descr_ and a _string_ and send the string to the file_descr. It uses _unix_.

_MongoReply_ is the type that contains the reply MongoDB.

**_Mongo_ and _MongoAdmin_ are desired to be extended. They contain the real client-faced high level APIs.**

### Misco

The current version is **0.66.0**.













