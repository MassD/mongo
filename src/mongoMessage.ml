open MongoUtils;;

exception Unknown_op_code;;

type operation = 
  | OP_REPLY
  | OP_UPDATE
  | OP_INSERT
  | RESERVED
  | OP_QUERY
  | OP_GET_MORE
  | OP_DELETE
  | OP_KILL_CURSORS;;

type header = 
    {
      message_len: int32; 
      request_id: int32;
      response_to: int32;
      op: operation
    };;

let op_to_code = function
  | OP_REPLY -> 1l
  | OP_UPDATE -> 2001l
  | OP_INSERT -> 2002l
  | RESERVED -> 2003l
  | OP_QUERY -> 2004l
  | OP_GET_MORE -> 2005l
  | OP_DELETE -> 2006l
  | OP_KILL_CURSORS -> 2007l;;

let op_of_code = function
  | 1l -> OP_REPLY
  | 2001l -> OP_UPDATE
  | 2002l -> OP_INSERT
  | 2003l -> RESERVED
  | 2004l -> OP_QUERY
  | 2005l -> OP_GET_MORE
  | 2006l -> OP_DELETE
  | 2007l -> OP_KILL_CURSORS
  | _ -> raise Unknown_op_code;;

let create_header body_len request_id op =
  {
    message_len = Int32.of_int(body_len+4*4);
    request_id = request_id;
    response_to = 0l;
    op = op
  };;

let encode_header h =
  let buf = Buffer.create 8 in
  encode_int32 buf h.message_len;
  encode_int32 buf h.request_id;
  encode_int32 buf h.response_to;
  encode_int32 buf (op_to_code (h.op));
  Buffer.contents buf;;

let decode_header str =
  let (message_len, next) = decode_int32 str 0 in
  let (request_id, next) = decode_int32 str next in
  let (response_to, next) = decode_int32 str next in
  let (op_code, next) = decode_int32 str next in
  {
    message_len = message_len;
    request_id = request_id;
    response_to = response_to;
    op = op_of_code op_code
  };;







