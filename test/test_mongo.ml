open Bson;;
open MongoUtils;;
open MongoReply;;

let m = Mongo.connect_local 27017;;

(*let _ = print_buffer (MongoMessage.dbs_cmd);;*)

let dbs_reply = Mongo.get_dbs m;;

let _ = 
  match dbs_reply.document_list with
    | [] -> print_endline "finished get dbs_docs"
    | hd::tl -> print_endline (to_simple_json hd);;

let _ = Mongo.close m;;
