open MongoUtils;;

type t = 
    { 
      header: MongoHeader.t;
      response_flags: int32;
      cursor_id: int64;
      starting_from: int32;
      num_returned: int32;
      document_list: Bson.t list
    };;

let get_header r = r.header;;
let get_response_flags r = r.response_flags;;
let get_cursor r = r.cursor_id;;
let get_starting_from r = r.starting_from;;
let get_num_returned r = r.num_returned;;
let get_document_list r = r.document_list;;

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
  let header = MongoHeader.decode_header header_str in
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

let to_string r = 
  let buf = Buffer.create 128 in
  Buffer.add_string buf (MongoHeader.to_string r.header);
  Buffer.add_string buf "response_flags = ";
  Buffer.add_string buf (Int32.to_string r.response_flags);
  Buffer.add_string buf "\n";
  Buffer.add_string buf "cursor_id = ";
  Buffer.add_string buf (Int64.to_string r.cursor_id);
  Buffer.add_string buf "\n";
  Buffer.add_string buf "starting_from = ";
  Buffer.add_string buf (Int32.to_string r.starting_from);
  Buffer.add_string buf "\n";
  Buffer.add_string buf "num_returned = ";
  Buffer.add_string buf (Int32.to_string r.num_returned);
  Buffer.add_string buf "\n";
  let rec print_doc_list = function
    | [] -> print_endline ""
    | hd::tl -> 
      Buffer.add_string buf "doc list: ";
      Buffer.add_string buf (Bson.to_simple_json hd);
      Buffer.add_string buf "\n";
      print_doc_list tl
  in 
  print_doc_list r.document_list;
  Buffer.contents buf;;
  


      
