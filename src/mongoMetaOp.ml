(* cf: http://docs.mongodb.org/manual/reference/operator/ *)

type meta_op =
  | Comment of string
  | MaxScan of int
  | Max of Bson.t
  | Min of Bson.t
  | OrderBy of Bson.t

let meta_op query op =
  let r =
    if Bson.has_element "$query" query then query
    else
      Bson.add_element "$query" (Bson.create_doc_element query) Bson.empty
  in

  match op with
    | Comment c ->
      Bson.add_element "$comment" (Bson.create_string c) r
    | MaxScan i ->
      Bson.add_element "$maxScan" (Bson.create_int32 (Int32.of_int i)) r
    | Max max_bson ->
      Bson.add_element "$max" (Bson.create_doc_element max_bson) r
    | Min min_bson ->
      Bson.add_element "$min" (Bson.create_doc_element min_bson) r
    | OrderBy orderby_bson ->
      Bson.add_element "$orderby" (Bson.create_doc_element orderby_bson) r


let comment c query =
  meta_op query (Comment c)
let maxScan i query =
  meta_op query (MaxScan i)
let min i query =
  meta_op query (Min i)
let max i query =
  meta_op query (Max i)
let orderBy o query =
  meta_op query (OrderBy o)
