open Bson;;

let print_buffer s = 
  String.iter (fun c -> let i = Char.code c in if i < 10 then Printf.printf "\\x0%X" i else Printf.printf "\\x%X" i) s;
  print_endline "";;

let m = Mongo.connect_local 27017;;

let _ = print_buffer (MongoMessage.dbs_cmd);;

let dbs_doc = Mongo.get_dbs m;;

(*let _ = print_endline (to_simple_json dbs_doc);;*)


let _ = Mongo.close m;;
