open MongoUtils;;
open MongoRequest;;
open Bson;;

type t = Mongo.t;;

type cmd = 
    {
      name: string;
      query: string;
    };;

let admin_db_name = "admin";;
let admin_collection_name = "$cmd";;

let create ip port  = Mongo.create ip port admin_db_name admin_collection_name;;
let create_local_default () = 
  create "127.0.0.1" 27017;;

let destory a = Mongo.desotry a;;

let empty_doc = make ();;
let e_1 = create_int32 (1l);;

let create_cmd_query query_doc = 
  create_query (cur_timestamp()) "admin" "$cmd" 0l 0l (-1l) query_doc empty_doc;;
let cmd_doc name = Bson.add_element name e_1 empty_doc;;
let create_cmd name = 
  let empty_doc = make()
  {
    name=name; 
    query = create_cmd_query (cmd_doc name)
  };;
  
let send_cmd m cmd = MongoSend.send_with_reply cmd.cmd_query;

let listdatabases m = send_cmd m (create_cmd "listDatabases");;
let buildInfo m = send_cmd m (create_cmd "buildInfo");;
let collStats m = send_cmd m (create_cmd "collStats");;
let connPoolStats m = send_cmd m (create_cmd "connPoolStats");;
let cursorInfo m = send_cmd m (create_cmd "cursorInfo");;
let getCmdLineOpts m = send_cmd m (create_cmd "getCmdLineOpts");;
let hostInfo m = send_cmd m (create_cmd "hostInfo");;
let listCommands m = send_cmd m (create_cmd "listCommands");;
let serverStatus m = send_cmd m (create_cmd "serverStatus");;
