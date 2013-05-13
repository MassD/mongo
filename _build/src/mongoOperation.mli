(** 
    This module defines the types of operation that are used in MongoDB requests and replies.
*)

(** Raised when dealing with an unknown operation code *)
exception Unknown_op_code;;

(** type of operations allowed in MongoDB *)
type t = 
  | OP_REPLY
  | OP_UPDATE
  | OP_INSERT
  | RESERVED
  | OP_QUERY
  | OP_GET_MORE
  | OP_DELETE
  | OP_KILL_CURSORS;;

(** {6 Convert between operation and int32 code} *)

(** convert an operation to an int32 *)
val to_code: t -> int32;;

(** convert an int32 to an operation, Unknwon_op_code will be raised if the code cannot be recognised *)
val of_code: int32 -> t;;
