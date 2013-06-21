(**
   This module defines the header for every message sent to or received from MongoDB.
*)

(** type of header *)
type t;;

(** {6 Header creation} *)

(** create a general header. e.g. create_header body_len request_id response_to op *)
val create_header: int -> int32 -> int32 -> MongoOperation.t -> t;;

(** create a request header. e.g. create_request_header body_len request_id op. The only difference from create_header is that parameter response_to is not necessary here *)
val create_request_header: int -> int32 -> MongoOperation.t -> t;;

(** {6 Values from header} *)

(** get the message length out of a header *)
val get_message_len: t -> int32;;

(** get the request id out of a header  *)
val get_request_id: t -> int32;;

(** get the response_to id out of a header  *)
val get_response_to: t -> int32;;

(** get the operation out of a header *)
val get_op: t -> MongoOperation.t;;

(** {6 operations on header} *)

(** encode the header to string, so it can be combined with the message body and sent *)
val encode_header: t -> string;;

(** decode a str (received from MongoDB) to a header *)
val decode_header: string -> t;;

(** convert a header to a human readable string *)
val to_string: t -> string;;
