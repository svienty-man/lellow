# lellow
An app to find all things Yellow

First need to run the node JS server generated from Swagger

./nodejs/npm install

./nodejs/node .

Or if you prefer run the node JS server modified from Swagger to use Express

./express/npm install

./express/node .

Or if you prefer to run the app against a Express Generator API

cd ./newexp/lellow

npm install

DEBUG=lellow:* PORT=8080 npm start

Then run the app to read the data source and put up a list of "Lellow" things to map out.
