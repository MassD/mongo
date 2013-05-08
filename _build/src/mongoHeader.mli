type t;;

val create_header: int -> int32 -> int32 -> MongoOperation.t -> t;;

val create_request_header: int -> int32 -> MongoOperation.t -> t;;

val get_message_len: t -> int32;;
val get_request_id: t -> int32;;
val get_response_to: t -> int32;;
val get_op: t -> MongoOperation.t;;

val encode_header: t -> string;;

val decode_header: string -> t;;

val to_string: t -> string;;
