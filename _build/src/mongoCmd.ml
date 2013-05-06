open MongoUtils;;
open MongoRequest;;
open Bson;;

let empty_doc = make ();;

let create_cmd_query query_doc = 
  create_query (cur_timestamp()) "admin" "$cmd" 0l 0l (-1l) query_doc empty_doc;;

let get_dbs_cmd_doc = Bson.add_element "listDatabases" (create_int32 (1l)) empty_doc;;
let get_dbs_cmd_query = create_cmd_query get_dbs_cmd_doc;;
