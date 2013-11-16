
(** {6 Query Operator Array} *)

(** [all el] selects the documents where the value of a field is an array
    that contains all the specified elements *)
val all : Bson.element list -> Bson.t

(** [elemMatch d] matches more than one component within an array element. *)
val elemMatch : Bson.t -> Bson.t

(** [size s] matches any array with the number of elements specified
    by the argument. *)
val size : int -> Bson.t
