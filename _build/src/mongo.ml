open MongoMessage;;
open MongoUtils;;
open Bson;;


let wrap_unix f arg = 
  try (f arg) with
      Unix.Unix_error (e, fm, argm) ->
	Printf.printf "%s %s %s" (Unix.error_message e) fm argm;;

type t = Unix.file_descr;;

let create ip port = 
    let c_descr = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
    let s_addr = Unix.ADDR_INET ((Unix.inet_addr_of_string ip), port) in
    Unix.connect c_descr s_addr; 
    c_descr;;

let connect mongo_ip mongo_port =  
  create mongo_ip mongo_port;;

let connect_local mongo_port = 
  create "127.0.0.1" mongo_port;;

let close mongo = Unix.close mongo;;

(*let read_len in_ch = 
  let buf = String.make 4 0 in
  let rec read total = 
    if total = 4 then buf
    else begin buf.total *)
 
let chr0 = Char.chr 0;;

let read_reply in_ch =
  let len_str = String.make 4 chr0 in
  really_input in_ch len_str 0 4;
  let (len32, _) = decode_int32 len_str 0 in
  let len = Int32.to_int len32 in
  let str = String.make (len-4) chr0 in
  really_input in_ch str 0 (len-4);
  str;;

let decode_reply_doc str =
  let rec decode_doc cur acc =
    if cur >= String.length str then acc
    else 
      let (len32, _) = decode_int32 str cur in
      let len = Int32.to_int len32 in
      Printf.printf "sub len = %d \n" len;
      decode_doc (cur+len) ((decode (String.sub str cur len))::acc)
  in
  List.rev (decode_doc 0 []);;

let decode_reply str =
  let (request_id, next) = decode_int32 str 0 in
  Printf.printf "request_id = %ld \n" request_id;
  let (response_to, next) = decode_int32 str next in
  Printf.printf "response_to = %ld \n" response_to;
  let (op_code, next) = decode_int32 str next in
  Printf.printf "op_code = %ld \n" op_code;
  let (flags, next) = decode_int32 str next in
  Printf.printf "flags = %ld \n" flags;
  let (cursor, next) = decode_int64 str next in
  Printf.printf "cursor = %Ld \n" cursor;
  let (from, next) = decode_int32 str next in
  Printf.printf "from = %ld \n" from;
  let (returned, next) = decode_int32 str next in
  Printf.printf "returned = %ld \n" returned;
  let doc_str = String.sub str next ((String.length str)-next) in
  Printf.printf "doc str len = %d \n" (String.length doc_str);
  Printf.printf "doc str = %s \n" doc_str;
  decode_reply_doc doc_str;;
  
let get_dbs m =
  let in_ch = Unix.in_channel_of_descr m in
  let out_ch = Unix.out_channel_of_descr m in
  output_string out_ch dbs_cmd;
  print_endline "output dbs_cmd";
  flush out_ch;
  print_endline "flushed dbs_cmd and waiting for answer";
  decode_reply (read_reply in_ch);;
