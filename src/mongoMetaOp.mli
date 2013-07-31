(* cf: http://docs.mongodb.org/manual/reference/operator/ *)

(* Attach a comment to a query *)
val comment : string -> Bson.t -> Bson.t
(* Constrains the query to only scan the specified number of documents when fulfilling the query
   Note: Contrary to what the official documentation say, it doesn't limit the number of documents a cursor will return for a query but limit the number of document the query will scan
*)
val maxScan : int -> Bson.t -> Bson.t
(* Specify the exclusive upper bound for a specific index in order to constrain the results of a query *)
val max : int -> Bson.t -> Bson.t
(* specify the inclusive lower bound for a specific index in order to constrain the results of a query *)
val min : int -> Bson.t -> Bson.t
(* Sorts the results of a query *)
val orderBy : Bson.t -> Bson.t -> Bson.t
