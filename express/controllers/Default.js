'use strict';

var url = require('url');


var Default = require('./DefaultService');


module.exports.questionsGET = function questionsGET (req, res, next) {
  Default.questionsGET(req.swagger.params, res, next);
};
