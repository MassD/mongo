open MongoUtils;;

exception MongoAdmin_failed of string;;

type t = Mongo_lwt.t;;

type cmd = { name: string; query: string};;

let admin_db_name = "admin";;
let admin_collection_name = "$cmd";;

let get_db_name = Mongo_lwt.get_db_name;;
let get_collection_name = Mongo_lwt.get_collection_name;;
let get_ip = Mongo_lwt.get_ip;;
let get_port = Mongo_lwt.get_port;;
let get_channels = Mongo_lwt.get_channels;;
let get_output_channel = Mongo_lwt.get_output_channel;;
let get_input_channel = Mongo_lwt.get_input_channel;;

let wrap_bson f arg =
  try (f arg) with
    | Bson.Invalid_objectId -> raise (MongoAdmin_failed "Bson.Invalid_objectId")
    | Bson.Wrong_bson_type -> raise (MongoAdmin_failed "Wrong_bson_type when encoding bson doc")
    | Bson.Malformed_bson -> raise (MongoAdmin_failed "Malformed_bson when decoding bson");;

let wrap_unix_lwt f arg =
  try_lwt (f arg) with
    | Unix.Unix_error (e, _, _) -> raise (MongoAdmin_failed (Unix.error_message e));;

let create ip port  = Mongo_lwt.create ip port admin_db_name admin_collection_name;;
let create_local_default () = create "127.0.0.1" 27017;;

let destory a = Mongo_lwt.destory a;;

let get_request_id = cur_timestamp;;

let create_cmd name =
  let e_1 = Bson.create_int32 (1l) in
  let cmd_doc name = Bson.add_element name e_1 Bson.empty in
  {
    name=name;
    query =
      let find_in (flags, skip, return, q, s) =
	MongoRequest.create_query (admin_db_name, admin_collection_name) (get_request_id(), flags, skip, return) (q,s) in
      wrap_bson find_in (0l, 0l, (-1l), (cmd_doc name), Bson.empty)
  }

let send_cmd (a,cmd) = MongoSend_lwt.send_with_reply (Mongo_lwt.get_channels a) cmd.query;;

let listDatabases a = wrap_unix_lwt send_cmd (a, create_cmd "listDatabases");;
let buildInfo a = wrap_unix_lwt send_cmd (a, create_cmd "buildInfo");;
let collStats a = wrap_unix_lwt send_cmd (a, create_cmd "collStats");;
let connPoolStats a = wrap_unix_lwt send_cmd (a, create_cmd "connPoolStats");;
let cursorInfo a = wrap_unix_lwt send_cmd (a, create_cmd "cursorInfo");;
let getCmdLineOpts a = wrap_unix_lwt send_cmd (a, create_cmd "getCmdLineOpts");;
let hostInfo a = wrap_unix_lwt send_cmd (a, create_cmd "hostInfo");;
let listCommands a = wrap_unix_lwt send_cmd (a, create_cmd "listCommands");;
let serverStatus a = wrap_unix_lwt send_cmd (a, create_cmd "serverStatus");;
