type t;;

val create: string -> int -> -> t;;

val create_local_default: unit -> t;;

val destory: t -> unit;;

val listDatabases: t -> MongoReply.t;;
val buildInfo: t -> MongoReply.t;;
val collStats: t -> MongoReply.t;;
val connPoolStats: t -> MongoReply.t;;
val cursorInfo: t -> MongoReply.t;;
val getCmdLineOpts: t -> MongoReply.t;;
val hostInfo: t -> MongoReply.t;;
val listCommands: t -> MongoReply.t;;
val serverStatus: t -> MongoReply.t;;
