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

