(* cf: http://docs.mongodb.org/manual/reference/operator/ *)

(* Attach a comment to a query *)
val comment : string -> Bson.t -> Bson.t
(* Constrains the query to only scan the specified number of documents when fulfilling the query
   Note: Contrary to what the official documentation say, it doesn't limit the number of documents a cursor will return for a query but limit the number of document the query will scan
*)
val maxScan : int -> Bson.t -> Bson.t
(* Specify the exclusive upper bound for a specific index in order to constrain the results of a query *)
val max : Bson.t -> Bson.t -> Bson.t
(* specify the inclusive lower bound for a specific index in order to constrain the results of a query *)
val min : Bson.t -> Bson.t -> Bson.t
(* Sorts the results of a query *)
val orderBy : Bson.t -> Bson.t -> Bson.t
(* Provides information on the query plan *)
val explain : Bson.t -> Bson.t
(* Forces the query optimizer to use a specific index to fulfill the query*)
val hint : Bson.t -> Bson.t -> Bson.t
(* Only return the index field or fields for the results of the query *)
val returnKey : Bson.t -> Bson.t
(* Adds a field $diskLoc to the returned documents. The $diskLoc field contains the disk location information *)
val showDiskLoc : Bson.t -> Bson.t
(* Prevents the cursor from returning a document more than once because an intervening write operation results in a move of the document *)
val snapshot : Bson.t -> Bson.t
