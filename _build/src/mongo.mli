(**
   {b This is a major client-faced module, for the high level usage.}

   This module includes a series of APIs that client can use directly to communicate with MongoDB. The most important functions are for insert, udpate, delete, query, get_more. They are the essential interactions that a client can have with MongoDB.

   Please note that the current version of APIs here are all essential only. For example, Clients cannot set detailed flags for queries, etc. All operations here are with default flags (which is 0).
   
   A Mongo is bound to a db and a collection. All operations will be done upon the bound db and collection only.

   Please refer to {{: http://docs.mongodb.org/meta-driver/latest/legacy/mongodb-wire-protocol/ } MongoDB Wire Protocol } for more information
*)

(** the exception will be raised if anything is wrong, with a string message *)
exception Mongo_failed of string;;

(** the type for Mongo *)
type t;;

(** {6 Essential info of a Mongo} *)

val get_db_name: t -> string;;
val get_collection_name: t -> string;;
val get_ip: t -> string;;
val get_port: t -> int;;
val get_file_descr: t -> Unix.file_descr;;

(** {6 Lifecycle of a Mongo} *)

(** create a Mongo. {b please note that Mongo is bound to a db and a collection.} e.g. create ip port db_name collection_name. May raise Mongo_failed exception.*)
val create: string -> int -> string -> string -> t;;

(** create a Mongo connecting to 127.0.0.1, port 27017. e.g. create_local_default db_name collection_name. May raise Mongo_failed exception.*)
val create_local_default: string -> string -> t;;

(** destory a Mongo. Please use this to destory a Mongo once it finishes its purpose, in order to release system resources. May raise Mongo_failed exception.*)
val destory: t -> unit;;

(** {6 Insert} *)

(** insert a list of bson documents into MongoDB. May raise Mongo_failed exception. *)
val insert: t -> Bson.t list -> unit;;

(** {6 Update} *)

(** update the {b first document} matched in MongoDB. e.g., update_one m (s, u);; m is the Mongo. s is the selector document, used to match the documents that need to be updated. u is the update document and any matched documents will be updated to u. May raise Mongo_failed exception.*)
val update_one: t-> Bson.t * Bson.t -> unit;;

(** update {b all documents} matched in MongoDB. e.g., update m (s, u);; m is the Mongo. s is the selector document, used to match the documents that need to be updated. u is the update document and any matched documents will be updated to u. May raise Mongo_failed exception. *)
val update_all: t-> Bson.t * Bson.t -> unit;;

(** {6 Delete} *)

(** delete the {b first document} matched in MongoDB. e.g., delete_one m s;; m is the Mongo. s is the selector document, used to match the documents that need to be deleted. May raise Mongo_failed exception.*)
val delete_one: t-> Bson.t -> unit;;

(** delete the {b all documents} matched in MongoDB. e.g., delete_one m s;; m is the Mongo. s is the selector document, used to match the documents that need to be deleted. May raise Mongo_failed exception.*)
val delete_all: t-> Bson.t -> unit;;

(** {6 Query / Find} *)

(** find {b all / the default number} of documents in the db and collection. May raise Mongo_failed exception.*)
val find: t -> MongoReply.t;;

(** find {b the first} document in the db and collection. May raise Mongo_failed exception.*)
val find_one: t -> MongoReply.t;;

(** find {b the desired number} of documents in the db and collection. May raise Mongo_failed exception.*)
val find_of_num: t -> int -> MongoReply.t;;

(** find {b all / the default number} of documents in the db and collection matching the bson query. May raise Mongo_failed exception.*)
val find_q: t -> Bson.t -> MongoReply.t;;

(** find {b the first} document in the db and collection matching the bson query. May raise Mongo_failed exception.*)
val find_q_one: t -> Bson.t -> MongoReply.t;;

(** find {b the desired number} of documents in the db and collection matching the bson query. May raise Mongo_failed exception.*)
val find_q_of_num: t -> Bson.t -> int -> MongoReply.t;;

(** find {b all / the default number} of documents in the db and collection matching the bson query, each document returned will only contains elements specified in the selector doc. May raise Mongo_failed exception.*)
val find_q_s: t -> Bson.t -> Bson.t -> MongoReply.t;;

(** find {b the first} documents in the db and collection matching the bson query, each document returned will only contains elements specified in the selector doc. May raise Mongo_failed exception.*)
val find_q_s_one: t -> Bson.t -> Bson.t -> MongoReply.t;;

(** find {b the desired number} of documents in the db and collection matching the bson query, each document returned will only contains elements specified in the selector doc. May raise Mongo_failed exception.*)
val find_q_s_of_num: t -> Bson.t -> Bson.t -> int -> MongoReply.t;;

(** {6 Query / Find more via cursor} *)

(** get {b the desired number} of documents via a cursor_id. e.g. get_more_of_num m cursor_id num. May raise Mongo_failed exception.*)
val get_more_of_num: t -> int64 -> int -> MongoReply.t;;

(** get {b all / the default number} of documents via a cursor_id. e.g. get_more_of_num m cursor_id num. May raise Mongo_failed exception.*)
val get_more: t -> int64 -> MongoReply.t;;

(** {6 Kill cursor} *)

(** kill a list of cursors, to save MongoDB resources. e.g., kill_cursors m cursor_list. May raise Mongo_failed exception.*)
val kill_cursors: t -> int64 list -> unit;;

(** {6 Index} *)

(** ensure an index and force it to be unique *)
val ensure_index: t -> string -> bool -> unit;;

(*
(** simply remove an index *)
val remove_index: t -> string -> unit;;*)
