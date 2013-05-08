open MongoUtils;;

type t = 
    {
      db_name: string;
      collection_name: string;
      ip: string;
      port: int;
      file_descr: Unix.file_descr
    };;

let get_db_name m = m.db_name;;
let get_collection_name m = m.collection_name;;
let get_ip m = m.ip;;
let get_port m = m.port;;
let get_file_descr m = m.file_descr;;

let connect_to ip port = 
    let c_descr = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
    let s_addr = Unix.ADDR_INET ((Unix.inet_addr_of_string ip), port) in
    Unix.connect c_descr s_addr; 
    c_descr;;

let create ip port db_name collection_name = 
  {
    db_name = db_name;
    collection_name = collection_name;
    ip = ip;
    port = port;
    file_descr = connect_to ip port
  };;

let create_local_default db_name collection_name = 
  create "127.0.0.1" 27017 db_name collection_name;;

let destory m = Unix.close m.file_descr;;

let insert m doc_list =
  let request_str = MongoRequest.create_insert (cur_timestamp()) m.db_name m.collection_name 0l doc_list in
  MongoSend.send_no_reply m.file_descr request_str;;






let wrap_unix f arg = 
  try (f arg) with
      Unix.Unix_error (e, fm, argm) ->
	Printf.printf "%s %s %s" (Unix.error_message e) fm argm;;


