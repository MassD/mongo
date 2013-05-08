
let _ = print_endline "=========testing Mongo";;
let m = Mongo.create_local_default "test_db" "test_collection";;
let empty_doc = Bson.make();;
let e_1 = Bson.create_int32 (1l);;
let key_doc = Bson.add_element "key" e_1 empty_doc;;
let _ = Mongo.insert m [key_doc];; 
let _ = print_endline "=========tested Mongo";;




let _ = print_endline "=========testing MongoAdmin";;
let a = MongoAdmin.create_local_default();;

let _ = print_endline "==listDatabases";;
let dbs_reply = MongoAdmin.listDatabases a;;
let _ = print_endline (MongoReply.to_string dbs_reply);;

let _ = print_endline "==buildInfo";;
let buildInfo_reply = MongoAdmin.buildInfo a;;
let _ = print_endline (MongoReply.to_string buildInfo_reply);;

let _ = print_endline "==collStats";;
let collStats_reply = MongoAdmin.collStats a;;
let _ = print_endline (MongoReply.to_string collStats_reply);;

let _ = print_endline "==connPoolStats";;
let connPoolStats_reply = MongoAdmin.connPoolStats a;;
let _ = print_endline (MongoReply.to_string connPoolStats_reply);;

let _ = print_endline "==cursorInfo";;
let cursorInfo_reply = MongoAdmin.cursorInfo a;;
let _ = print_endline (MongoReply.to_string cursorInfo_reply);;

let _ = print_endline "==getCmdLineOpts";;
let getCmdLineOpts_reply = MongoAdmin.getCmdLineOpts a;;
let _ = print_endline (MongoReply.to_string getCmdLineOpts_reply);;

let _ = print_endline "==hostInfo";;
let hostInfo_reply = MongoAdmin.hostInfo a;;
(*let _ = print_endline (MongoReply.to_string hostInfo_reply);;*)

let _ = print_endline "==listCommands";;
let listCommands_reply = MongoAdmin.listCommands a;;
let _ = print_endline (MongoReply.to_string listCommands_reply);;

let _ = print_endline "==serverStatus";;
let serverStatus_reply = MongoAdmin.serverStatus a;;
let _ = print_endline (MongoReply.to_string serverStatus_reply);;

let _ = print_endline "=========tested MongoAdmin";;


