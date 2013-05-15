open MongoUtils;;
open MongoOperation;;
open MongoHeader;;
open Bson;;

let combine_header_body request_id op body_buf = 
  let body_len = Buffer.length body_buf in
  let whole_buf = Buffer.create (4*4+body_len) in
  let header_str = encode_header (create_request_header body_len request_id op) in
  Buffer.add_string whole_buf header_str;
  Buffer.add_buffer whole_buf body_buf;
  Buffer.contents whole_buf;;

let create_insert (db_name,collection_name) (request_id,flags) insert_doc_list =
  let body_buf = Buffer.create 32 in
  encode_int32 body_buf flags;
  encode_cstring body_buf (db_name^"."^collection_name);
  let rec add_doc = function
    | [] -> ()
    | hd::tl -> 
      Buffer.add_string body_buf (encode hd);
      add_doc tl
  in
  add_doc insert_doc_list;
  combine_header_body request_id OP_INSERT body_buf;;

let create_select_body_buf (db_name,collection_name) (request_id,flags) selector_doc =
  let body_buf = Buffer.create 32 in
  encode_int32 body_buf 0l;
  encode_cstring body_buf (db_name^"."^collection_name);
  encode_int32 body_buf flags;
  Buffer.add_string body_buf (encode selector_doc);
  body_buf;;

let create_update (db_name,collection_name) (request_id,flags) (selector_doc,update_doc) =
  let body_buf = create_select_body_buf (db_name,collection_name) (request_id,flags) selector_doc in
  Buffer.add_string body_buf (encode update_doc);
  combine_header_body request_id OP_UPDATE body_buf;;

let create_delete (db_name,collection_name) (request_id,flags) selector_doc =
  let body_buf = create_select_body_buf (db_name,collection_name) (request_id,flags) selector_doc in
  combine_header_body request_id OP_DELETE body_buf;;

let create_query (db_name,collection_name) (request_id,flags,skip,return) (query_doc,selector_doc) =
  (*Printf.printf "request_id = %ld\n" request_id;*)
  let body_buf = Buffer.create 32 in
  encode_int32 body_buf flags;
  encode_cstring body_buf (db_name^"."^collection_name);
  encode_int32 body_buf skip;
  encode_int32 body_buf return;
  Buffer.add_string body_buf (encode query_doc);
  if not (Bson.is_empty selector_doc) then Buffer.add_string body_buf (encode selector_doc);
  combine_header_body request_id OP_QUERY body_buf;;

let create_get_more (db_name,collection_name) (request_id,return) cursor =
  let body_buf = Buffer.create 32 in
  encode_int32 body_buf 0l;
  encode_cstring body_buf (db_name^"."^collection_name);
  encode_int32 body_buf return;
  encode_int64 body_buf cursor;
  combine_header_body request_id OP_GET_MORE body_buf;;

let create_kill_cursors request_id cursor_list =
  let body_buf = Buffer.create 32 in
  encode_int32 body_buf 0l;
  let cursor_buf = Buffer.create 12 in
  let rec create_cursor_buf num = function
    | [] -> num
    | hd::tl -> 
      encode_int64 cursor_buf hd;
      create_cursor_buf (num+1) tl
  in 
  let num = create_cursor_buf 0 cursor_list in
  encode_int32 body_buf (Int32.of_int num);
  Buffer.add_buffer body_buf cursor_buf;
  combine_header_body request_id OP_KILL_CURSORS body_buf;;

  
