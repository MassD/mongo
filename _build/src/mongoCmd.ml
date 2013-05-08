open MongoUtils;;
open MongoRequest;;
open Bson;;

type t = 
    {
      name: string;
      query: string;
    };;

let get_name c = c.name;;
let get_query c = c.query;;

let empty_doc = make ();;
let e_1 = create_int32 (1l);;

let create_cmd_query query_doc = 
  create_query (cur_timestamp()) "admin" "$cmd" 0l 0l (-1l) query_doc empty_doc;;

let cmd_doc name = Bson.add_element name e_1 empty_doc;;
let create_cmd name = 
  {
    name=name; 
    query = create_cmd_query (cmd_doc name)
  };;
  
let listDatabases_cmd = create_cmd "listDatabases";;
let buildInfo_cmd = create_cmd "buildInfo";;
let collStats_cmd = create_cmd "collStats";;
let connPoolStats_cmd = create_cmd "connPoolStats";;
let cursorInfo_cmd = create_cmd "cursorInfo";;
let getCmdLineOpts_cmd = create_cmd "getCmdLineOpts";;
let hostInfo_cmd = create_cmd "hostInfo";;
let listCommands_cmd = create_cmd "listCommands";;
let serverStatus_cmd = create_cmd "serverStatus";;

