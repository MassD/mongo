
(*** Logical Query operator  *)

let or_op d_list =
  Bson.add_element "$or" (Bson.create_doc_element_list d_list) Bson.empty

let and_op d_list =
  Bson.add_element "$and" (Bson.create_doc_element_list d_list) Bson.empty

let not_op e =
  Bson.add_element "$not" e Bson.empty

let nor_op d_list =
  Bson.add_element "$nor" (Bson.create_doc_element_list d_list) Bson.empty

(*** Query Operator Array *)

let all e_list =
  Bson.add_element "$all" (Bson.create_list e_list) Bson.empty

let elemMatch d =
  Bson.add_element "$elemMatch" (Bson.create_doc_element d) Bson.empty

let size i =
  Bson.add_element "$size" (Bson.create_int32 (Int32.of_int i)) Bson.empty
