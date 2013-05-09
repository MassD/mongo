type t;;

val get_db_name: t -> string;;
val get_collection_name: t -> string;;
val get_ip: t -> string;;
val get_port: t -> int;;
val get_file_descr: t -> Unix.file_descr;;

val create: string -> int -> string -> string -> t;;

val create_local_default: string -> string -> t;;

val destory: t -> unit;;

val insert: t -> Bson.t list -> unit;;

val update_one: t-> Bson.t * Bson.t -> unit;;
val update_all: t-> Bson.t * Bson.t -> unit;;

val delete_one: t-> Bson.t -> unit;;
val delete_all: t-> Bson.t -> unit;;

val find: t -> MongoReply.t;;
val find_one: t -> MongoReply.t;;
val find_of_num: t -> int -> MongoReply.t;;

val find_q: t -> Bson.t -> MongoReply.t;;
val find_q_one: t -> Bson.t -> MongoReply.t;;
val find_q_of_num: t -> Bson.t -> int -> MongoReply.t;;

val get_more_of_num: t -> int64 -> int -> MongoReply.t;;
val get_more: t -> int64 -> MongoReply.t;;

val kill_cursors: t -> int64 list -> unit;;
