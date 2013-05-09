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


let get_request_id = cur_timestamp;;


let insert_in m = MongoRequest.create_insert (m.db_name, m.collection_name);;
let insert m doc_list =
  let request_str = insert_in m (get_request_id(), 0l) doc_list in
  MongoSend.send_no_reply m.file_descr request_str;;

let update_in m = MongoRequest.create_update (m.db_name, m.collection_name);;
let update_one m (s,u) = 
  let request_str = update_in m (get_request_id(), 0l) (s,u) in
  MongoSend.send_no_reply m.file_descr request_str;;
let update_all m (s,u) = 
  let request_str = update_in m (get_request_id(), 2l) (s,u) in
  MongoSend.send_no_reply m.file_descr request_str;;

let delete_in m = MongoRequest.create_delete (m.db_name, m.collection_name);;
let delete_one m s = 
  let request_str = delete_in m (get_request_id(), 1l) s in
  MongoSend.send_no_reply m.file_descr request_str;;
let delete_all m s = 
  let request_str = delete_in m (get_request_id(), 0l) s in
  MongoSend.send_no_reply m.file_descr request_str;;

let find_in m = MongoRequest.create_query (m.db_name, m.collection_name);;
let find m = 
  let request_str = find_in m (get_request_id(),0l,0l,0l) (Bson.empty, Bson.empty) in
  MongoSend.send_with_reply m.file_descr request_str;;
let find_one m = 
  let request_str = find_in m (get_request_id(),0l,0l,1l) (Bson.empty, Bson.empty) in
  MongoSend.send_with_reply m.file_descr request_str;;
let find_of_num m num = 
  let request_str = find_in m (get_request_id(),0l,0l,Int32.of_int num) (Bson.empty, Bson.empty) in
  MongoSend.send_with_reply m.file_descr request_str;;
let find_q m q = 
  let request_str = find_in m (get_request_id(),0l,0l,0l) (q, Bson.empty) in
  MongoSend.send_with_reply m.file_descr request_str;;
let find_q_one m q = 
  let request_str = find_in m (get_request_id(),0l,0l,1l) (q, Bson.empty) in
  MongoSend.send_with_reply m.file_descr request_str;;
let find_q_of_num m q num = 
  let request_str = find_in m (get_request_id(),0l,0l,Int32.of_int num) (q, Bson.empty) in
  MongoSend.send_with_reply m.file_descr request_str;;

let get_more_in m = MongoRequest.create_get_more (m.db_name, m.collection_name);;
let get_more_of_num m c num = 
  let request_str = get_more_in m (get_request_id(), Int32.of_int num) c in
  MongoSend.send_with_reply m.file_descr request_str;;
let get_more m c = get_more_of_num m c 0;;

let kill_cursors m c_list = 
  let request_str = MongoRequest.create_kill_cursors (get_request_id()) c_list in
  MongoSend.send_no_reply m.file_descr request_str;;

let wrap_unix f arg = 
  try (f arg) with
      Unix.Unix_error (e, fm, argm) ->
	Printf.printf "%s %s %s" (Unix.error_message e) fm argm;;


