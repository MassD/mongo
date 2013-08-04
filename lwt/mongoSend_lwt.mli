(**
   This module simply define two functions used as underlying low level unix socket output.
*)


(** this function just send a string out via the supplied file_descr. It does not wait for any reponses. immediately finishes.*)
val send_no_reply: (Lwt_io.input_channel * Lwt_io.output_channel) Lwt_pool.t -> string -> unit Lwt.t;;

(** this function will send the string and wait for a response as a MongoReply *)
val send_with_reply: (Lwt_io.input_channel * Lwt_io.output_channel) Lwt_pool.t -> string -> MongoReply.t Lwt.t;;
