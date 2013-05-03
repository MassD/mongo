open MongoUtils;;
open Bson;;

type operation = 
  | OP_REPLY
  | OP_UPDATE
  | OP_INSERT
  | RESERVED
  | OP_QUERY
  | OP_GET_MORE
  | OP_DELETE
  | OP_KILL_CURSORS;;

let op_code = function
  | OP_REPLY -> 1l
  | OP_UPDATE -> 2001l
  | OP_INSERT -> 2002l
  | RESERVED -> 2003l
  | OP_QUERY -> 2004l
  | OP_GET_MORE -> 2005l
  | OP_DELETE -> 2006l
  | OP_KILL_CURSORS -> 2007l;;

let create_header request_id op body_buf = 
  let buf = Buffer.create 8 in
  encode_int32 buf (Int32.of_int((Buffer.length body_buf)+4));
  encode_int32 buf request_id;
  encode_int32 buf 0l;
  encode_int32 buf op;
  buf;;

let create_query request_id db_name collection_name option skip return query_doc selector_doc =
  let buf = Buffer.create 16 and body_buf = Buffer.create 32 in
  encode_int32 body_buf option;
  encode_cstring body_buf (db_name^"."^collection_name);
  encode_int32 body_buf skip;
  encode_int32 body_buf return;
  Buffer.add_string body_buf (encode query_doc);
  if not (is_empty selector_doc) then Buffer.add_string body_buf (encode selector_doc);
  Buffer.add_buffer buf (create_header request_id (op_code OP_QUERY) body_buf);
  Buffer.add_buffer buf body_buf;
  Buffer.contents buf;;

let dbs_cmd = create_query 0l "admin" "$cmd" 0l 0l 0l (add_element "listDatabases" (create_int32 (-1l)) (make ())) (make());;


  





