open MongoUtils;;
open MongoCmd;;

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

let send_cmd m cmd = 
  let in_ch = Unix.in_channel_of_descr m in
  let out_ch = Unix.out_channel_of_descr m in
  output_string out_ch cmd.cmd_query;
  
  flush out_ch;
  Printf.printf "sent cmd %s" cmd.cmd_name;
  MongoReply.decode_reply (read_reply in_ch);;

let get_databases m = send_cmd m listDatabases_cmd;;
let get_buildInfo m = send_cmd m buildInfo_cmd;;
let get_collStats m = send_cmd m collStats_cmd;;
let get_connPoolStats m = send_cmd m connPoolStats_cmd;;
let get_cursorInfo m = send_cmd m cursorInfo_cmd;;
let get_getCmdLineOpts m = send_cmd m getCmdLineOpts_cmd;;
let get_hostInfo m = send_cmd m hostInfo_cmd;;
let get_listCommands m = send_cmd m buildInfo_cmd;;
let get_serverStatus m = send_cmd m serverStatus_cmd;;




