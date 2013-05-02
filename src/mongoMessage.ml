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

let encode_int32 buf v = 
  for i = 0 to 3 do
    let b = Int32.logand 255l (Int32.shift_right v (i*8)) in
    Buffer.add_char buf (Char.chr (Int32.to_int b))
  done;;

let encode_int64 buf v =
  for i = 0 to 7 do
    let b = Int64.logand 255L (Int64.shift_right v (i*8)) in
    Buffer.add_char buf (Char.chr (Int64.to_int b))
  done;;

let encode_cstring buf cs = 
  Buffer.add_string buf cs; 
  Buffer.add_char buf '\x00';;

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
  Buffer.add_string body_buf (Bson.encode query_doc);
  if not (Bson.is_empty selector_doc) then Buffer.add_string body_buf (Bson.encode selector_doc);
  Buffer.add_buffer buf (create_header request_id (op_code OP_QUERY) body_buf);
  Buffer.add_buffer buf body_buf;
  Buffer.contents buf;;
  
  



let decode_int64 str cur =
  let rec decode i acc =
    if i < cur then acc
    else
      let high_byte = Char.code str.[i] in
      let high_int64 = Int64.of_int high_byte in
      let shift_acc = Int64.shift_left acc 8 in
      let new_acc = Int64.logor high_int64 shift_acc in 
      decode (i-1) new_acc
  in (decode (cur+7) 0L, cur+8)

let decode_float str cur = 
  let (i, new_cur) = decode_int64 str cur in
  (Int64.float_of_bits i, new_cur);;

let decode_int32 str cur = 
  let rec decode i acc =
    if i < cur then acc
    else
      let high_byte = Char.code str.[i] in
	(*print_int high_byte;print_endline "";*)
      let high_int32 = Int32.of_int high_byte in
      let shift_acc = Int32.shift_left acc 8 in
      let new_acc = Int32.logor high_int32 shift_acc in 
      decode (i-1) new_acc
  in (decode (cur+3) 0l, cur+4);;

let rec next_x00 str cur = String.index_from str cur '\x00';;

let decode_cstring str cur = 
  let x00 = next_x00 str cur in
  if x00 = -1 then raise Bson.Malformed_bson
  else (String.sub str cur (x00-cur), x00+1);;

