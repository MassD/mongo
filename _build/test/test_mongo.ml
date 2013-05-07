(*open Bson;;
open MongoUtils;;
open MongoReply;;*)

let m = Mongo.connect_local 27017;;


let dbs_reply = Mongo.get_databases m;;
let _ = MongoReply.print_reply dbs_reply;;
(*
let buildInfo_reply = Mongo.get_buildInfo m;;
let _ = MongoReply.print_reply buildInfo_reply;;

let collStats_reply = Mongo.get_collStats m;;
let _ = MongoReply.print_reply collStats_reply;;

let connPoolStats_reply = Mongo.get_connPoolStats m;;
let _ = MongoReply.print_reply connPoolStats_reply;;

let cursorInfo_reply = Mongo.get_cursorInfo m;;
let _ = MongoReply.print_reply cursorInfo_reply;;

let getCmdLineOpts_reply = Mongo.get_getCmdLineOpts m;;
let _ = MongoReply.print_reply getCmdLineOpts_reply;;

let hostInfo_reply = Mongo.get_hostInfo m;;
let _ = MongoReply.print_reply hostInfo_reply;;

let listCommands_reply = Mongo.get_listCommands m;;
let _ = MongoReply.print_reply listCommands_reply;;

let serverStatus_reply = Mongo.get_serverStatus m;;
let _ = MongoReply.print_reply serverStatus_reply;;
*)

let empty_doc = Bson.make();;
let e_1 = Bson.create_int32 (1l);;
let key_doc = Bson.add_element "key" e_1 empty_doc;;

let _ = Mongo.insert m "test123" "keys" [key_doc];; 

(*let _ = Mongo.close m;;*)
