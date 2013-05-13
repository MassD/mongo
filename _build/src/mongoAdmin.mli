(**
   {b This is a major client-faced module, for the high level usage.}

   This module includes a series of APIs that client can use directly to obtain some admin level of information about a MongoDB, e.g., the list of databases inside, etc.
   Currently all commands are read-only ones, which means they are just retrieving infomation from MongoDB, not setting any configurations.
   
   Please refer to {{: http://docs.mongodb.org/manual/reference/command/ } MongoDB Commands } for more information
*)

(** the exception will be raised if anything is wrong, with a string message *)
exception MongoAdmin_failed of string;;

(** the type for MongoAdmin *)
type t;;

(** {6 Essential info of a MongoAdmin} *)

val get_db_name: t -> string;;
val get_collection_name: t -> string;;
val get_ip: t -> string;;
val get_port: t -> int;;
val get_file_descr: t -> Unix.file_descr;;

(** {6 Lifecycle of a MongoAdmin} *)

(** create a MongoAdmin. e.g. create ip port. May raise MongoAdmin_failed exception.*)
val create: string -> int -> t;;

(** create a MongoAdmin connecting to 127.0.0.1, port 27017. May raise MongoAdmin_failed exception.*)
val create_local_default: unit -> t;;

(** destory a MongoAdmin. Please use this to destory a MongoAdmin once it finishes its purpose, in order to release system resources. May raise MongoAdmin_failed exception.*)
val destory: t -> unit;;

(** {6 Commands via a MongoAdmin, may raise MongoAdmin_failed exception.} *)

val listDatabases: t -> MongoReply.t;;
val buildInfo: t -> MongoReply.t;;
val collStats: t -> MongoReply.t;;
val connPoolStats: t -> MongoReply.t;;
val cursorInfo: t -> MongoReply.t;;
val getCmdLineOpts: t -> MongoReply.t;;
val hostInfo: t -> MongoReply.t;;
val listCommands: t -> MongoReply.t;;
val serverStatus: t -> MongoReply.t;;
