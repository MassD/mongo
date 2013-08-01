open MongoUtils;;

exception Mongo_failed of string;;

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

let wrap_bson f arg =
  try (f arg) with
    | Bson.Invalid_objectId -> raise (Mongo_failed "Bson.Invalid_objectId")
    | Bson.Wrong_bson_type -> raise (Mongo_failed "Wrong_bson_type when encoding bson doc")
    | Bson.Malformed_bson -> raise (Mongo_failed "Malformed_bson when decoding bson");;

let wrap_unix f arg =
  try (f arg) with
    | Unix.Unix_error (e, _, _) -> raise (Mongo_failed (Unix.error_message e));;

let connect_to (ip,port) =
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
    file_descr = wrap_unix connect_to (ip,port)
  };;

let create_local_default db_name collection_name =
  create "127.0.0.1" 27017 db_name collection_name;;

let destory m = wrap_unix Unix.close m.file_descr;;


let get_request_id = cur_timestamp;;

let send_only (m, str) = MongoSend.send_no_reply m.file_descr str;;
let send (m,str) = MongoSend.send_with_reply m.file_descr str;;

let insert_in (m, flags, doc_list) = MongoRequest.create_insert (m.db_name, m.collection_name) (get_request_id(),flags) doc_list;;
let insert m doc_list = wrap_unix send_only (m, wrap_bson insert_in (m, 0l, doc_list));;

let update_in (m, flags, s, u) = MongoRequest.create_update (m.db_name, m.collection_name) (get_request_id(), flags) (s,u);;
let update_one m (s,u) = wrap_unix send_only (m, wrap_bson update_in (m, 0l, s, u));;
let update_all m (s,u) = wrap_unix send_only (m, wrap_bson update_in (m, 2l, s, u));;

let delete_in (m, flags, s) = MongoRequest.create_delete (m.db_name, m.collection_name) (get_request_id(), flags) s;;
let delete_one m s = wrap_unix send_only (m, wrap_bson delete_in (m, 1l, s));;
let delete_all m s = wrap_unix send_only (m, wrap_bson delete_in (m, 0l, s));;

let find_in (m, flags, skip, return, q, s) =
  MongoRequest.create_query (m.db_name, m.collection_name) (get_request_id(), flags, skip, return) (q,s);;
let find m = wrap_unix send (m, wrap_bson find_in (m, 0l, 0l, 0l, Bson.empty, Bson.empty));;
let find_one m = wrap_unix send (m, wrap_bson find_in (m, 0l, 0l, 1l, Bson.empty, Bson.empty));;
let find_of_num m num = wrap_unix send (m, wrap_bson find_in (m, 0l, 0l, (Int32.of_int num), Bson.empty, Bson.empty));;
let find_q m q = wrap_unix send (m, wrap_bson find_in (m, 0l, 0l, 0l, q, Bson.empty));;
let find_q_one m q = wrap_unix send (m, wrap_bson find_in (m, 0l, 0l, 1l, q, Bson.empty));;
let find_q_of_num m q num = wrap_unix send (m, wrap_bson find_in (m, 0l, 0l, (Int32.of_int num), q, Bson.empty));;
let find_q_s m q s = wrap_unix send (m, wrap_bson find_in (m, 0l, 0l, 0l, q, s));;
let find_q_s_one m q s = wrap_unix send (m, wrap_bson find_in (m, 0l, 0l, 1l, q, s));;
let find_q_s_of_num m q s num = wrap_unix send (m, wrap_bson find_in (m, 0l, 0l, (Int32.of_int num), q, s));;

let get_more_in (m, c, num) = MongoRequest.create_get_more (m.db_name, m.collection_name) (get_request_id(), Int32.of_int num) c;;
let get_more_of_num m c num = wrap_unix send (m, wrap_bson get_more_in (m, c, num));;
let get_more m c = get_more_of_num m c 0;;

let kill_cursors_in c_list = MongoRequest.create_kill_cursors (get_request_id()) c_list;;
let kill_cursors m c_list = wrap_unix send_only (m, wrap_bson kill_cursors_in c_list);;

let change_collection m c =
  { m with
      collection_name = c ;
  }

let drop_database m =
  let m = change_collection m "$cmd" in
  find_q_one m (Bson.add_element "dropDatabase" (Bson.create_int32 1l) Bson.empty)

let drop_collection m =
  let m_ = change_collection m "$cmd" in
  find_q_one m_ (Bson.add_element "drop" (Bson.create_string m.collection_name) Bson.empty)


(** INDEX **)
let get_indexes m =
  let m_ = change_collection m "system.indexes" in
  find_q m_ (Bson.add_element "ns" (Bson.create_string (m.db_name ^ "." ^ m.collection_name)) Bson.empty)

type option =
  | Background of bool
  | Unique of bool
  | Name of string
  | DropDups of bool
  | Sparse of bool
  | ExpireAfterSeconds of int
  | V of int
  | Weight of Bson.t
  | Default_language of string
  | Language_override of string

let ensure_index m key_bson options =
  let default_name () =
    let doc = Bson.get_element "key" key_bson in

    List.fold_left (
      fun s (k,e) ->
        let i = Bson.get_int32 e in
        if s = "" then
          Printf.sprintf "%s_%ld" k i
        else
          Printf.sprintf "%s_%s_%ld" s k i
    ) "" (Bson.all_elements (Bson.get_doc_element doc))
  in

  let has_name = ref false in
  let has_version = ref false in
  (* check all options *)

  let main_bson =
    List.fold_left (
      fun acc o ->
        match o with
          | Background b ->
            Bson.add_element "background" (Bson.create_boolean b) acc
          | Unique b ->
            Bson.add_element "unique" (Bson.create_boolean b) acc
          | Name s ->
            has_name := true;
            Bson.add_element "name" (Bson.create_string s) acc
          | DropDups b ->
            Bson.add_element "dropDups" (Bson.create_boolean b) acc
          | Sparse b ->
            Bson.add_element "sparse" (Bson.create_boolean b) acc
          | ExpireAfterSeconds i ->
            Bson.add_element "expireAfterSeconds" (Bson.create_int32 (Int32.of_int i)) acc
          | V i ->
            if i <> 0 && i <> 1 then raise (Mongo_failed "Version number for index must be 0 or 1");
            has_version := true;
            Bson.add_element "v" (Bson.create_int32 (Int32.of_int i)) acc
          | Weight bson ->
            Bson.add_element "weights" (Bson.create_doc_element bson) acc
          | Default_language s ->
            Bson.add_element "default_language" (Bson.create_string s) acc
          | Language_override s ->
            Bson.add_element "language_override" (Bson.create_string s) acc
    ) key_bson options
  in

  (* check if then name has been set, create a default name otherwise *)
  let main_bson =
    if !has_name = false then begin
      Bson.add_element "name" (Bson.create_string (default_name ())) main_bson
    end else main_bson
  in

  (* check if the version has been set, set 1 otherwise *)
  let main_bson =
    if !has_version = false then
      Bson.add_element "v" (Bson.create_int32 1l) main_bson
    else main_bson
  in

  let main_bson = Bson.add_element "ns" (Bson.create_string (m.db_name ^ "." ^ m.collection_name)) main_bson in
  (* print_endline (Bson.to_simple_json main_bson); *)

  let system_indexes_m = change_collection m "system.indexes" in

  insert system_indexes_m [main_bson];;


let ensure_simple_index ?(options=[]) m field =
  let key_bson = Bson.add_element "key" (Bson.create_doc_element (Bson.add_element field (Bson.create_int32 1l) Bson.empty)) Bson.empty in
  ensure_index m key_bson options

let ensure_multi_simple_index ?(options=[]) m fields =
  let key_bson =
    List.fold_left (
      fun acc f ->
        Bson.add_element f (Bson.create_int32 1l) acc
    ) Bson.empty fields
  in

  let key_bson = Bson.add_element "key" (Bson.create_doc_element key_bson) Bson.empty in
  ensure_index m key_bson options

let drop_index m index_name =
  let index_bson = Bson.add_element "index" (Bson.create_string index_name) Bson.empty in
  let delete_bson = Bson.add_element "deleteIndexes" (Bson.create_string m.collection_name) index_bson in
  let m = change_collection m "$cmd" in
  find_q m delete_bson

let drop_all_index m =
  drop_index m "*"
