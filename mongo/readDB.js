printjson(db.getCollectionNames());

var retjson = db.locations.find({"ID" : 16560});

printjson(retjson.toArray());

retjson = db.locations.find();

printjson (retjson.toArray());