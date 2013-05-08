type t;;

val create: string -> int -> string -> string -> t;;

val create_local_default: string -> string -> t;;

val destory: t -> unit;;

val insert: t -> Bson.t list -> unit;;
