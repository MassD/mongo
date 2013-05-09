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
  (*print_endline str;
  Printf.printf "doc str len = %d\n" (String.length str);*)
  let rec decode_doc cur acc =
    if cur >= String.length str then acc
    else 
      let (len32, _) = decode_int32 str cur in
      let len = Int32.to_int len32 in
      (*Printf.printf "inside doc len = %d\n" len;*)
      decode_doc (cur+len) ((Bson.decode (String.sub str cur len))::acc)
  in
  List.rev (decode_doc 0 []);;

let decode_reply str =
  (*Printf.printf "real message len = %d\n" (String.length str);*)
  let header_str = String.sub str 0 (4*4) in
  let header = MongoHeader.decode_header header_str in
  (*print_endline (MongoHeader.to_string header);*)
  let (flags, next) = decode_int32 str (4*4) in
  let (cursor, next) = decode_int64 str next in
  let (from, next) = decode_int32 str next in
  let (returned, next) = decode_int32 str next in
  (*print_endline (string_of_int (Int32.to_int returned));*)
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
  Buffer.add_string buf "doc list: ";
  Buffer.add_string buf "\n";
  let rec process_doc_list = function
    | [] -> ()
    | hd::tl -> 
      Buffer.add_string buf (Bson.to_simple_json hd);
      Buffer.add_string buf "\n";
      process_doc_list tl
  in 
  process_doc_list r.document_list;
  Buffer.contents buf;;
  


      
