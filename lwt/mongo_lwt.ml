open MongoUtils;;

exception Mongo_failed of string;;

type t =
    {
      db_name: string;
      collection_name: string;
      ip: string;
      port: int;
      channels : (Lwt_io.input_channel * Lwt_io.output_channel)
    };;

let get_db_name m = m.db_name;;
let get_collection_name m = m.collection_name;;
let get_ip m = m.ip;;
let get_port m = m.port;;
let get_channels m = m.channels;;
let get_output_channel m =
  let _,o = get_channels m in
  o
let get_input_channel m =
  let i,_ = get_channels m in
  i

let wrap_bson f arg =
  try (f arg) with
    | Bson.Invalid_objectId -> raise (Mongo_failed "Bson.Invalid_objectId")
    | Bson.Wrong_bson_type -> raise (Mongo_failed "Wrong_bson_type when encoding bson doc")
    | Bson.Malformed_bson -> raise (Mongo_failed "Malformed_bson when decoding bson");;

let wrap_unix_lwt f arg =
  try_lwt (f arg) with
    | Unix.Unix_error (e, _, _) -> raise (Mongo_failed (Unix.error_message e));;

let connect_to (ip,port) =
  let s_addr = Lwt_unix.ADDR_INET (Unix.inet_addr_of_string ip,port) in
  Lwt_io.open_connection s_addr

let create ip port db_name collection_name =
  lwt channels = wrap_unix_lwt connect_to (ip,port) in
  Lwt.return {
    db_name = db_name;
    collection_name = collection_name;
    ip = ip;
    port = port;
    channels;
  };;

let create_local_default db_name collection_name =
  create "127.0.0.1" 27017 db_name collection_name;;

let destory m =
  let i,o = m.channels in
  lwt _ = wrap_unix_lwt Lwt_io.close i in
  wrap_unix_lwt Lwt_io.close o ;;

let get_request_id = cur_timestamp;;

let send_only (m, str) = MongoSend_lwt.send_no_reply m.channels str;;
let send (m,str) = MongoSend_lwt.send_with_reply m.channels str;;

let insert_in (m, flags, doc_list) = MongoRequest.create_insert (m.db_name, m.collection_name) (get_request_id(),flags) doc_list;;
let insert m doc_list = wrap_unix_lwt send_only (m, wrap_bson insert_in (m, 0l, doc_list));;

let update_in (m, flags, s, u) = MongoRequest.create_update (m.db_name, m.collection_name) (get_request_id(), flags) (s,u);;
let update_one m (s,u) = wrap_unix_lwt send_only (m, wrap_bson update_in (m, 0l, s, u));;
let update_all m (s,u) = wrap_unix_lwt send_only (m, wrap_bson update_in (m, 2l, s, u));;

let delete_in (m, flags, s) = MongoRequest.create_delete (m.db_name, m.collection_name) (get_request_id(), flags) s;;
let delete_one m s = wrap_unix_lwt send_only (m, wrap_bson delete_in (m, 1l, s));;
let delete_all m s = wrap_unix_lwt send_only (m, wrap_bson delete_in (m, 0l, s));;

let find_in (m, flags, skip, return, q, s) =
  MongoRequest.create_query (m.db_name, m.collection_name) (get_request_id(), flags, skip, return) (q,s);;
let find m = wrap_unix_lwt send (m, wrap_bson find_in (m, 0l, 0l, 0l, Bson.empty, Bson.empty));;
let find_one m = wrap_unix_lwt send (m, wrap_bson find_in (m, 0l, 0l, 1l, Bson.empty, Bson.empty));;
let find_of_num m num = wrap_unix_lwt send (m, wrap_bson find_in (m, 0l, 0l, (Int32.of_int num), Bson.empty, Bson.empty));;
let find_q m q = wrap_unix_lwt send (m, wrap_bson find_in (m, 0l, 0l, 0l, q, Bson.empty));;
let find_q_one m q = wrap_unix_lwt send (m, wrap_bson find_in (m, 0l, 0l, 1l, q, Bson.empty));;
let find_q_of_num m q num = wrap_unix_lwt send (m, wrap_bson find_in (m, 0l, 0l, (Int32.of_int num), q, Bson.empty));;
let find_q_s m q s = wrap_unix_lwt send (m, wrap_bson find_in (m, 0l, 0l, 0l, q, s));;
let find_q_s_one m q s = wrap_unix_lwt send (m, wrap_bson find_in (m, 0l, 0l, 1l, q, s));;
let find_q_s_of_num m q s num = wrap_unix_lwt send (m, wrap_bson find_in (m, 0l, 0l, (Int32.of_int num), q, s));;

let get_more_in (m, c, num) = MongoRequest.create_get_more (m.db_name, m.collection_name) (get_request_id(), Int32.of_int num) c;;
let get_more_of_num m c num = wrap_unix_lwt send (m, wrap_bson get_more_in (m, c, num));;
let get_more m c = get_more_of_num m c 0;;

let kill_cursors_in c_list = MongoRequest.create_kill_cursors (get_request_id()) c_list;;
let kill_cursors m c_list = wrap_unix_lwt send_only (m, wrap_bson kill_cursors_in c_list);;

(* currently the implementation is far not enough *)
let ensure_index m index unique =
  let doc =
    let key_doc =
      Bson.add_element "key" (Bson.create_doc_element (Bson.add_element index (Bson.create_int32 1l) Bson.empty)) Bson.empty in
    let main_doc =
      Bson.add_element "name" (Bson.create_string index) (
	Bson.add_element "v" (Bson.create_int32 1l)
	  (Bson.add_element "ns" (Bson.create_string (m.db_name ^ "." ^ m.collection_name)) key_doc))
    in
    if unique then Bson.add_element "unique" (Bson.create_boolean true) main_doc
    else main_doc
  in
  print_endline (Bson.to_simple_json doc);
  let system_indexes_m =
    {
    db_name = m.db_name;
    collection_name = "system.indexes";
    ip = m.ip;
    port = m.port;
    channels = m.channels ;
    } in
  insert system_indexes_m [doc];;
