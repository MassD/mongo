
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

(*** Field Update Operator  *)

let inc d =
  Bson.add_element "$inc" (Bson.create_doc_element d) Bson.empty

let rename d =
  Bson.add_element "$rename" (Bson.create_doc_element d) Bson.empty

let setOnInsert d =
  Bson.add_element "$setOnInsert" (Bson.create_doc_element d) Bson.empty

let set d =
  Bson.add_element "$set" (Bson.create_doc_element d) Bson.empty

let unset d =
  Bson.add_element "$unset" (Bson.create_doc_element d) Bson.empty

(*** Array Update Operator  *)

let addToSet d =
  Bson.add_element "$addToSet" (Bson.create_doc_element d) Bson.empty

let pop d =
  Bson.add_element "$pop" (Bson.create_doc_element d) Bson.empty

let pullAll d =
  Bson.add_element "$pullAll" (Bson.create_doc_element d) Bson.empty

let pull d =
  Bson.add_element "$pull" (Bson.create_doc_element d) Bson.empty

let pushAll d =
  Bson.add_element "$pushAll" (Bson.create_doc_element d) Bson.empty

let push d =
  Bson.add_element "$push" (Bson.create_doc_element d) Bson.empty

let each el =
  Bson.add_element "$each" (Bson.create_list el) Bson.empty

let slice i =
  Bson.add_element "$slice" (Bson.create_int32 (Int32.of_int i)) Bson.empty

let sort d =
  Bson.add_element "$sort" (Bson.create_doc_element d) Bson.empty
