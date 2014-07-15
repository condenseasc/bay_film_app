/*global ooCalendar, console*/
'use strict';

ooCalendar.factory('Name', [ 'Week', function(Week){
  var Name = {
    // take a date and return a string format YYYYMMDD
    date: function(date){
      if (!(date instanceof Date)){
        console.log("invalid Date input for Name.date: "+date);
      }

      // console.log("input for Name.date: "+date);
      var day = date.getDate();
      if (day<10) day = "0"+day;
      var month = date.getMonth()+1;
      if (month<10) month = "0"+month;
      var year = date.getFullYear();

      var date_string = ""+year+month+day; 
      // console.log("output from Name.date: "+date_string);
      return date_string;
    },

    // return a YYYYMMDD string representing a page, which in turn represents a week
    // the string name is built from a week's first day, Sunday
    page: function(date){
      if (!(date instanceof Date)){
        console.log("invalid Date input for Name.page: "+date);
      }

      var sunday = Week.thisSunday(date);
      var date_string = this.date(sunday);

      return date_string;
    },

    // take in a YYYYMMDD string and return its Date object
    toDate: function(date){
      return new Date(+date.slice(0,4), +date.slice(4,6)-1, +date.slice(6,8));
    }
  };
  return Name;
}]);
