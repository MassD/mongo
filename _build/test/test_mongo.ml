let client = Mongo.connect_local 27017;;

let _ = Mongo.close client;;
