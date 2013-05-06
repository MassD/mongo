open MongoUtils;;
open MongoMessage;;
open Bson;;

let create_query request_id db_name collection_name flags skip return query_doc selector_doc =
  let body_buf = Buffer.create 32 in
  encode_int32 body_buf flags;
  encode_cstring body_buf (db_name^"."^collection_name);
  encode_int32 body_buf skip;
  encode_int32 body_buf return;
  Buffer.add_string body_buf (encode query_doc);
  if not (Bson.is_empty selector_doc) then Buffer.add_string body_buf (encode selector_doc);
  let body_len = Buffer.length body_buf in
  let header_str = encode_header (create_header body_len request_id OP_QUERY) in
  let query_buf = Buffer.create (4*4+body_len) in
  Buffer.add_string query_buf header_str;
  Buffer.add_buffer query_buf body_buf;
  Buffer.contents query_buf;;




  





