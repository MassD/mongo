val create_insert: int32 -> string -> string -> int32 -> Bson.t list -> string;;

val create_update: int32 -> string -> string -> int32 -> Bson.t -> Bson.t -> string;;

val create_delete: int32 -> string -> string -> int32 -> Bson.t -> string;;

val create_query: int32 -> string -> string -> int32 -> int32 -> int32 -> Bson.t -> Bson.t -> string;;

val create_get_more: int32 -> string -> string -> int32 -> int64 -> string;;

val create_kill_cursors: int32 -> int64 list -> string;;
