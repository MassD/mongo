(**
   This module create request string that can be sent to MongoDB.
   It takes according parameters and convert them to the desired bytes (string).
   Tuples are used as parameters, just to group similar parameters together, better for reading.
*)

(** create an insert request. e.g. create_insert (db_name,collection_name) (request_id,flags) insert_doc_list *)
val create_insert: string * string -> int32 * int32 -> Bson.t list -> string;;

(** create an update request. e.g. create_update (db_name,collection_name) (request_id,flags) (selector_doc,update_doc) *)
val create_update: string * string -> int32 *  int32 -> Bson.t *Bson.t -> string;;

(** create a delete reuqest. e.g. create_delete (db_name,collection_name) (request_id,flags) selector_doc *)
val create_delete: string * string -> int32 * int32 -> Bson.t -> string;;

(** create a query request. e.g. create_query (db_name,collection_name) (request_id,flags,skip,return) (query_doc,selector_doc) *)
val create_query: string * string -> int32 * int32 * int32 * int32 -> Bson.t * Bson.t -> string;;

(** create a get_more request. e.g.  create_get_more (db_name,collection_name) (request_id,return) cursor *)
val create_get_more: string * string -> int32 * int32 -> int64 -> string;;

(** create a kill_cursors request. e.g. create_kill_cursors request_id cursor_list *)
val create_kill_cursors: int32 -> int64 list -> string;;
