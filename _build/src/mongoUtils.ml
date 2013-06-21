let print_buffer s = 
  String.iter (fun c -> let i = Char.code c in if i < 10 then Printf.printf "\\x0%X" i else Printf.printf "\\x%X" i) s;
  print_endline "";;

let cur_timestamp () = Int32.of_float (Unix.time());;

let encode_int32 buf v = 
  for i = 0 to 3 do
    let b = Int32.logand 255l (Int32.shift_right v (i*8)) in
    Buffer.add_char buf (Char.chr (Int32.to_int b))
  done;;

let encode_int64 buf v =
  for i = 0 to 7 do
    let b = Int64.logand 255L (Int64.shift_right v (i*8)) in
    Buffer.add_char buf (Char.chr (Int64.to_int b))
  done;;

let encode_cstring buf cs = 
  Buffer.add_string buf cs; 
  Buffer.add_char buf '\x00';;

let decode_int32 str cur = 
  let rec decode i acc =
    if i < cur then acc
    else
      let high_byte = Char.code str.[i] in
	(*print_int high_byte;print_endline "";*)
      let high_int32 = Int32.of_int high_byte in
      let shift_acc = Int32.shift_left acc 8 in
      let new_acc = Int32.logor high_int32 shift_acc in 
      decode (i-1) new_acc
  in (decode (cur+3) 0l, cur+4);;

let decode_int64 str cur =
  let rec decode i acc =
    if i < cur then acc
    else
      let high_byte = Char.code str.[i] in
      let high_int64 = Int64.of_int high_byte in
      let shift_acc = Int64.shift_left acc 8 in
      let new_acc = Int64.logor high_int64 shift_acc in 
      decode (i-1) new_acc
  in (decode (cur+7) 0L, cur+8)

let rec next_x00 str cur = String.index_from str cur '\x00';;

let decode_cstring str cur = 
  let x00 = next_x00 str cur in
  if x00 = -1 then raise Bson.Malformed_bson
  else (String.sub str cur (x00-cur), x00+1);;

