open MongoUtils;;
open MongoRequest;;
open Bson;;

type cmd = 
    {
      cmd_name: string;
      cmd_query: string;
    };;

let empty_doc = make ();;

let create_cmd_query query_doc = 
  create_query (cur_timestamp()) "admin" "$cmd" 0l 0l (-1l) query_doc empty_doc;;

let e_1 = create_int32 (1l);;

let cmd_doc cmd_name = Bson.add_element cmd_name e_1 empty_doc;;
let create_cmd cmd_name = 
  {
    cmd_name=cmd_name; 
    cmd_query = create_cmd_query (cmd_doc cmd_name)
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

