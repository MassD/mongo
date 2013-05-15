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
let _ = print_endline (MongoReply.to_string hostInfo_reply);;

let _ = print_endline "==listCommands";;
let listCommands_reply = MongoAdmin.listCommands a;;
let _ = print_endline (MongoReply.to_string listCommands_reply);;

let _ = print_endline "==serverStatus";;
let serverStatus_reply = MongoAdmin.serverStatus a;;
let _ = print_endline (MongoReply.to_string serverStatus_reply);;

let _ = print_endline "=========tested MongoAdmin";;

let m = Mongo.create_local_default "test_db" "test_collection";;


let _ = print_endline "=========testing Mongo insert";;
let empty_doc = Bson.empty;;
let e_1 = Bson.create_int32 (1l);;
let key_doc = Bson.add_element "key" e_1 empty_doc;;
let _ = Mongo.insert m [key_doc];; 
let _ = print_endline "=========tested Mongo insert";;


let _ = print_endline "=========testing Mongo find";;
let r = Mongo.find m;;
let _ = print_endline (MongoReply.to_string r);;
let _ = print_endline "=========tested Mongo find";;

let _ = print_endline "\n=========testing Mongo find_one";;
let r = Mongo.find_one m;;
let _ = print_endline (MongoReply.to_string r);;
let _ = print_endline "=========tested Mongo find_one";;

let _ = print_endline "\n=========testing Mongo find_q";;
let q = Bson.add_element "name.first" (Bson.create_string "John") (Bson.empty);;
let r = Mongo.find_q m q;;
let _ = print_endline (MongoReply.to_string r);;
let _ = print_endline "=========tested Mongo find_q";;

let _ = print_endline "\n=========testing Mongo find_q_one";;
let q = Bson.add_element "key" (Bson.create_int32 1l) (Bson.empty);;
let r = Mongo.find_q_one m q;;
let _ = print_endline (MongoReply.to_string r);;
let _ = print_endline "=========tested Mongo find_q_one";;

let _ = print_endline "\n=========testing Mongo update";;
let s = Bson.add_element "key" (Bson.create_int32 2l) (Bson.empty);;
let set_doc = Bson.add_element "key" (Bson.create_int32 3l) (Bson.empty);;
let u = Bson.add_element "$set" (Bson.create_doc_element set_doc) (Bson.empty);;
let _ = Mongo.update_all m (s,u);;
let r = Mongo.find m;;
let _ = print_endline (MongoReply.to_string r);;
let _ = print_endline "=========tested Mongo update";;

let _ = print_endline "\n=========testing Mongo update";;
let s = Bson.add_element "key" (Bson.create_int32 1l) (Bson.empty);;
let _ = Mongo.delete_one m s;;
let r = Mongo.find m;;
let _ = print_endline (MongoReply.to_string r);;
let _ = print_endline "=========tested Mongo update";;

let _ = print_endline "\n=========testing Mongo get_more";;
let q = Bson.add_element "key" (Bson.create_int32 1l) (Bson.empty);;
let r = Mongo.find_q_of_num m q 2;;
let c = MongoReply.get_cursor r;;
let r = Mongo.get_more_of_num m c 2;;

let _ = print_endline (MongoReply.to_string r);;
let _ = print_endline "=========tested Mongo get_more";;

let _ = print_endline "\n=========testing Mongo kill_cursors";;
let _ = Mongo.kill_cursors m [c];;
let _ = print_endline "=========tested Mongo kill_cursors";;

let _ = print_endline "\n=========testing Mongo index";;
let _ = Mongo.ensure_index m "birth" true;;
let _ = print_endline "=========tested Mongo index";;
