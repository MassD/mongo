(** 
    This module defines reply that MongoDB sends back for a query.
*)

(** type of reply sent from MongoDB*)
type t;;

(** decode a string received from MongoDB to a MongoReply *)
val decode_reply: string -> t;;

(** {6 Values from a MongoReply} *)

(** get the MongoHeader out of a MongoReply *)
val get_header: t -> MongoHeader.t;;

(** get the response_flags field out of a MongoReply *)
val get_response_flags: t -> int32;;

(** get the cursor_id out of a MongoReply *)
val get_cursor: t -> int64;;

(** get the starting_from field out of a MongoReply *)
val get_starting_from: t -> int32;;

(** get the number of items returned out of a MongoReply *)
val get_num_returned: t -> int32;;

(** get the document list returned out of a MongoReply *)
val get_document_list: t -> Bson.t list;;

(** {6 Operations} *)

(** convert a MongoReply to a human readable string *)
val to_string: t -> string;;

