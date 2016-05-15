var express = require('express');
var router = express.Router();
var MongoClient = require('mongodb').MongoClient;
var retjson;

console.log("Questions script is called!");

// Connection URL
var url = 'mongodb://localhost:27017/test';

function retrieveData() {
  console.log("Retrieve Data is called!");

  MongoClient.connect(url, function(err, db) {
  console.log("Connected succesfully to mongo db server");

  console.log("Error return " + err);

  db.listCollections(function(err, collections){
        if (err) {
            throw err;
        } else {
            console.log("List Collections Returs: " + collections);
        }
  });
 
  var contentCollection = db.collection('locations');
  contentCollection.find({}).toArray(function(err, result) {
        if (err) {
            throw err;
        } else {
          console.log("We finally got here anyways!");
          console.log("Result Returns: " + result);
          console.dir(result);
          db.close();
        }
    });        
  });
}

/* GET users listing. */
router.get('/', function(req, res, next) {

console.log("Questions route is started!");
retrieveData();

var body, type, jresp;

  jresp = [ 
  { 
    "ID": 16553, 
    "Name": "French Market Canal", 
    "Latitude": 41.883976, 
    "Longitude": -87.639346, 
    "Address": "11 N Canal St L30 Chicago, IL 60606", 
    "ArrivalTime": "2016-04-05T04:37:54.36" 
  }, 
  { 
    "ID": 16554, 
    "Name": "Monk’s Pub", 
    "Latitude": 41.885791, 
    "Longitude": -87.634306, 
    "Address": "205 W Lake St, Chicago, IL 60606", 
    "ArrivalTime": "2016-04-05T09:23:54.36" 
  }, 
  { 
    "ID": 16555, 
    "Name": "Cubby Bear", 
    "Latitude": 41.947071, 
    "Longitude": -87.656705, 
    "Address": "1059 W Addison St, Chicago, IL 60613", 
    "ArrivalTime": "2016-04-05T06:38:54.36" 
  }, 
  { 
    "ID": 16556, 
    "Name": "Murphy’s Bleachers", 
    "Latitude": 41.949014, 
    "Longitude": -87.654087, 
    "Address": "3655 N Sheffield Ave, Chicago, IL 60613", 
    "ArrivalTime": "2016-04-05T01:14:54.36" 
  }, 
  { 
    "ID": 16557, 
    "Name": "Wrigley Field", 
    "Latitude": 41.948922, 
    "Longitude": -87.655278, 
    "Address": "1060 W Addison St, Chicago, IL 60613", 
    "ArrivalTime": "2016-04-05T07:16:54.36" 
  }, 
  { 
    "ID": 16558, 
    "Name": "Al’s Beef", 
    "Latitude": 41.893197, 
    "Longitude": -87.633901, 
    "Address": "169 W Ontario St, Chicago, IL 60654", 
    "ArrivalTime": "2016-04-05T09:06:54.36" 
  }, 
  { 
    "ID": 16559, 
    "Name": "Bull & Bear", 
    "Latitude": 41.890351, 
    "Longitude": -87.633665, 
    "Address": "431 N Wells St, Chicago, IL 60654", 
    "ArrivalTime": "2016-04-05T07:17:54.36" 
  }, 
  { 
    "ID": 16560, 
    "Name": "Frontera Grill", 
    "Latitude": 41.891398, 
    "Longitude": -87.630736, 
    "Address": "445 N Clark St, Chicago, IL 60654", 
    "ArrivalTime": "2016-04-04T22:17:54.36" 
  }, 
  { 
    "ID": 16561, 
    "Name": "Lou Malnatis Pizzeria", 
    "Latitude": 41.902197, 
    "Longitude": -87.632935, 
    "Address": "439 N Wells St, Chicago, IL 60654", 
    "ArrivalTime": "2016-04-05T02:10:54.36" 
  }, 
  { 
    "ID": 16562, 
    "Name": "Naf Naf Grill", 
    "Latitude": 41.883045, 
    "Longitude": -87.635689, 
    "Address": "309 W Washington St, Chicago, IL 60606", 
    "ArrivalTime": "2016-04-05T06:37:54.36" 
  }, 
  { 
    "ID": 16563, 
    "Name": "Tribune Tower", 
    "Latitude": 41.89031, 
    "Longitude": -87.623295, 
    "Address": "435 N Michigan Ave, Chicago, IL 60611", 
    "ArrivalTime": "2016-04-05T01:48:54.36" 
  } 
]

  type = "application/json";
  body = JSON.stringify(jresp);
  res.setHeader("Content-Type", type);
  res.statusCode = 200;

  res.end(body);
});

module.exports = router;
