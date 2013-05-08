type t;;

val get_header: t -> MongoHeader.t;;
val get_response_flags: t -> int32;;
val get_cursor: t -> int64;;
val get_starting_from: t -> int32;;
val get_num_returned: t -> int32;;
val get_document_list: t -> Bson.t list;;

val decode_reply: string -> t;;
val to_string: t -> string;;

