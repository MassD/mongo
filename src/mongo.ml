open MongoUtils;;

type t = 
    {
      db_name: string;
      collection_name: string;
      ip: string;
      port: int;
      file_descr: Unix.file_descr
    };;

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
  MongoSend.send_no_reply m (MongoRequest.create_insert (cur_timestamp()) m.db_name m.collection_name 0l doc_list);;






let wrap_unix f arg = 
  try (f arg) with
      Unix.Unix_error (e, fm, argm) ->
	Printf.printf "%s %s %s" (Unix.error_message e) fm argm;;


