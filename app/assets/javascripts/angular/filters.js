'use strict';
/* global angular */
var ooFilters = angular.module('ooFilters', []);

ooFilters.
// given an array of events, returns the array of events on a given day 
// requires a valid string description of a date as argument
filter('ooDay', function(){
  return function(input, date){
    var out = [];
    var day = new Date(date).setHours(0,0,0,0);

    if (typeof input === 'undefined') {return out;}
    for (var i = 0, len = input.length; i < len; i++) {
      var entry = input[i];
      var event_date = new Date(entry.time).setHours(0,0,0,0);
      if (event_date === day) {
        out.push(entry);
      }
    }
    return out;
  };
});