open MongoUtils;;
open Bson;;

type t = Mongo.t;;

type cmd = { name: string; query: string};;

let admin_db_name = "admin";;
let admin_collection_name = "$cmd";;

let get_db_name = Mongo.get_db_name;;
let get_collection_name = Mongo.get_collection_name;;
let get_ip = Mongo.get_ip;;
let get_port = Mongo.get_port;;
let get_file_descr = Mongo. get_file_descr;;

let create ip port  = Mongo.create ip port admin_db_name admin_collection_name;;
let create_local_default () = create "127.0.0.1" 27017;;

let destory a = Mongo.destory a;;

let create_cmd name = 
  let empty_doc = make() in
  let e_1 = create_int32 (1l) in
  let cmd_doc name = Bson.add_element name e_1 empty_doc in
  {
    name=name; 
    query =  MongoRequest.create_query (cur_timestamp()) admin_db_name admin_collection_name 0l 0l (-1l) (cmd_doc name) empty_doc
  };;
  
let send_cmd a cmd = MongoSend.send_with_reply (Mongo.get_file_descr a) cmd.query;;

let listDatabases a = send_cmd a (create_cmd "listDatabases");;
let buildInfo a = send_cmd a (create_cmd "buildInfo");;
let collStats a = send_cmd a (create_cmd "collStats");;
let connPoolStats a = send_cmd a (create_cmd "connPoolStats");;
let cursorInfo a = send_cmd a (create_cmd "cursorInfo");;
let getCmdLineOpts a = send_cmd a (create_cmd "getCmdLineOpts");;
let hostInfo a = send_cmd a (create_cmd "hostInfo");;
let listCommands a = send_cmd a (create_cmd "listCommands");;
let serverStatus a = send_cmd a (create_cmd "serverStatus");;
