(**
   This module contains some utility tools or helpers
*)

val print_buffer: string -> unit;;

val cur_timestamp: unit -> int32;;

val encode_int32: Buffer.t -> int32 -> unit;;

val encode_int64: Buffer.t -> int64 -> unit;;

val encode_cstring: Buffer.t -> string -> unit;;

val decode_int32: string -> int -> int32 * int;;

val decode_int64: string -> int -> int64 * int;;

val decode_cstring: string -> int -> string * int;;
