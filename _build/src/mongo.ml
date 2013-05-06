open MongoUtils;;

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

let chr0 = Char.chr 0;;

(* read complete reply portion, include complete message header *)
let read_reply in_ch =
  let len_str = String.make 4 chr0 in
  really_input in_ch len_str 0 4;
  let (len32, _) = decode_int32 len_str 0 in
  let len = Int32.to_int len32 in
  let str = String.make (len-4) chr0 in
  really_input in_ch str 0 (len-4);
  let buf = Buffer.create len in
  Buffer.add_string buf len_str;
  Buffer.add_string buf str;
  Buffer.contents buf;;

let get_dbs m =
  let in_ch = Unix.in_channel_of_descr m in
  let out_ch = Unix.out_channel_of_descr m in
  output_string out_ch MongoCmd.get_dbs_cmd_query;
  print_endline "output dbs_cmd";
  flush out_ch;
  print_endline "flushed dbs_cmd and waiting for answer";
  MongoReply.decode_reply (read_reply in_ch);;
