
(** {6 Logical Query Operator} *)

(** or_op operator performs a logical OR operation on an array of two or more
    expressions and selects the documents that satisfy at least one of
    the expressions.  *)
val or_op : Bson.t list -> Bson.t

(** and_op performs a logical AND operation on an array of two or
    more expressions and selects the documents that satisfy all
    the expressions in the array. *)
val and_op : Bson.t list -> Bson.t

(** not_op performs a logical NOT operation on the specified expression
    and selects the documents that do not match this expression.  *)
val not_op : Bson.element -> Bson.t

(** nor_op performs a logical NOR operation on an array of one or more
    query expression and selects the documents that fail all
    the query expressions in the array. *)
val nor_op : Bson.t list -> Bson.t

(** {6 Query Operator Array} *)

(** [all el] selects the documents where the value of a field is an array
    that contains all the specified elements *)
val all : Bson.element list -> Bson.t

(** [elemMatch d] matches more than one component within an array element. *)
val elemMatch : Bson.t -> Bson.t

(** [size s] matches any array with the number of elements specified
    by the argument. *)
val size : int -> Bson.t
