val create_insert: string * string -> int32 * int32 -> Bson.t list -> string;;

val create_update: string * string -> int32 *  int32 -> Bson.t *Bson.t -> string;;

val create_delete: string * string -> int32 * int32 -> Bson.t -> string;;

val create_query: string * string -> int32 * int32 * int32 * int32 -> Bson.t * Bson.t -> string;;

val create_get_more: string * string -> int32 * int32 -> int64 -> string;;

val create_kill_cursors: int32 -> int64 list -> string;;
