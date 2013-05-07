open MongoUtils;;

type reply = 
    { 
      header: MongoMessage.header;
      response_flags: int32;
      cursor_id: int64;
      starting_from: int32;
      num_returned: int32;
      document_list: Bson.t list
    };;

let decode_reply_doc str =
  let rec decode_doc cur acc =
    if cur >= String.length str then acc
    else 
      let (len32, _) = decode_int32 str cur in
      let len = Int32.to_int len32 in
      decode_doc (cur+len) ((Bson.decode (String.sub str cur len))::acc)
  in
  List.rev (decode_doc 0 []);;

let decode_reply str =
  let header_str = String.sub str 0 (4*4) in
  let header = MongoMessage.decode_header header_str in
  let (flags, next) = decode_int32 str (4*4) in
  let (cursor, next) = decode_int64 str next in
  let (from, next) = decode_int32 str next in
  let (returned, next) = decode_int32 str next in
  let doc_str = String.sub str next ((String.length str)-next) in
  let doc_list = decode_reply_doc doc_str in
  {
    header = header;
    response_flags = flags;
    cursor_id = cursor;
    starting_from = from;
    num_returned = returned;
    document_list = doc_list
  };;

let print_reply r =
  MongoMessage.print_header r.header;
  Printf.printf "response_flags = %ld \n" r.response_flags;
  Printf.printf "cursor_id = %Ld \n" r.cursor_id;
  Printf.printf "starting_from = %ld \n" r.starting_from;
  Printf.printf "num_returned = %ld \n" r.num_returned;
  let rec print_doc_list = function
    | [] -> print_endline ""
    | hd::tl -> print_endline (Bson.to_simple_json hd);print_doc_list tl
  in 
  print_doc_list r.document_list;;
  


      
