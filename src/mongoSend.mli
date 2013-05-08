val send_no_reply: Unix.file_descr -> string -> unit;;

val send_with_reply: Unix.file_descr -> string -> MongoReply.t;;
