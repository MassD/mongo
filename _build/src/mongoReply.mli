type reply = 
    { 
      header: MongoMessage.header;
      response_flags: int32;
      cursor_id: int64;
      starting_from: int32;
      num_returned: int32;
      document_list: Bson.t list
    };;

val decode_reply: string -> reply;;

