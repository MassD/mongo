exception Unknown_op_code;;

type t = 
  | OP_REPLY
  | OP_UPDATE
  | OP_INSERT
  | RESERVED
  | OP_QUERY
  | OP_GET_MORE
  | OP_DELETE
  | OP_KILL_CURSORS;;

val to_code: t -> int32;;
val of_code: int32 -> t;;
