
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

(** {6 Field Update Operator} *)

(** [inc d] increments a value of a field by a specified amount. *)
val inc : Bson.t -> Bson.t

(** [rename d] updates the name of a field. *)
val rename : Bson.t -> Bson.t

(** [setOnInsert d] assigns values to fields during an upsert
    only when using the upsert option to the update()
    operation performs an insert. *)
val setOnInsert : Bson.t -> Bson.t

(** [set d] replace the value of a field to the specified value. *)
val set : Bson.t -> Bson.t

(** [unset d] deletes a particular field.  *)
val unset : Bson.t -> Bson.t

(** {6 Array Update Operator} *)


(** [addToSet d] adds a value to an array
    only if the value is not in the array already.*)
val addToSet : Bson.t -> Bson.t

(** [pop d] removes the first or last element of an array. *)
val pop : Bson.t -> Bson.t

(** [pullAll d] removes multiple values from an existing array. *)
val pullAll : Bson.t -> Bson.t

(** [pull d] removes all instances of a value from an existing array. *)
val pull : Bson.t -> Bson.t

(** [pushAll d] similar to the $push
    but adds the ability to append several values to an array at once. *)
val pushAll : Bson.t -> Bson.t

(** [push d] appends a specified value to an array. *)
val push : Bson.t -> Bson.t

(** [each d] modifier is available for use with
    the $addToSet operator and the $push operator. *)
val each : Bson.element list -> Bson.t

(** [slice i] modifier limits the number of array elements
    during a $push operation.  *)
val slice : int -> Bson.t

(** [sort d] modifier orders the elements of an array during a $push operation. *)
val sort : Bson.t -> Bson.t
