open MongoUtils;;

let send_no_reply (_,out_ch) request_str =
  lwt _ = Lwt_io.write out_ch request_str in
  Lwt_io.flush out_ch;;

(* read complete reply portion, include complete message header *)
let read_reply (in_ch,_) =
  let chr0 = Char.chr 0 in
  let len_str = String.make 4 chr0 in
  lwt _ = Lwt_io.read_into_exactly in_ch len_str 0 4 in
  let (len32, _) = decode_int32 len_str 0 in
  let len = Int32.to_int len32 in
  (*print_endline (Int32.to_string len32);*)
  let str = String.make (len-4) chr0 in
  lwt _ = Lwt_io.read_into_exactly in_ch str 0 (len-4) in
  let buf = Buffer.create len in
  Buffer.add_string buf len_str;
  Buffer.add_string buf str;
  Lwt.return (Buffer.contents buf)

let send_with_reply channels request_str =
  lwt _ = send_no_reply channels request_str in
  lwt r = read_reply channels in
  let dr = MongoReply.decode_reply r in
  Lwt.return dr
