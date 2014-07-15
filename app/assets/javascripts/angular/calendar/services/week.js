/*global ooCalendar, console*/
'use strict';

ooCalendar.factory('Week', function(){
  var week_service = {
    //take a day and give its Sun-Sat range
    //in array of date objects set to midnight
    //{selected: @boolean, date: @Date}
    days: function(date){
      if (!(date instanceof Date)){
        console.log("invalid Date input for Week.days: "+date);
      }
      var w = [];
      var d = new Date(date);
      var d_day = d.getDay();
      var d_date = d.getDate();

      for(var i=0; i<7 ; i++){
        var offset = d_date + (i - d_day);
        var weekday = new Date(d);
        weekday.setDate(offset);

        var day_obj = {};
        day_obj.date = weekday;

        if (JSON.stringify(day_obj.date) == JSON.stringify(d))
          day_obj.selected = true;
        else day_obj.selected = false;

        w[i] = day_obj;
      }
      return w;
    },

    // take a day and give its bounding
    // sunday and saturday as two item array
    bounds: function(date){
      if (!(date instanceof Date)){
        console.log("invalid Date input for Week.bounds: "+date);
      }
      // should I take these out? not serving anything
      // or helping with errors
      var d = new Date(date);
      var d2 = new Date(date);
      var d_day = d.getDay();
      var d_date = d.getDate();
      var sunday_offset = d_date + (0-d_day);
      var saturday_offset = d_date + (6-d_day);

      var sunday = new Date(d.setDate(sunday_offset));
      var saturday = new Date(d2.setDate(saturday_offset));
      var w = [sunday, saturday];
      return w;
    },

    //take a day and give it back plus next 6 days
    //as array of date objects set to midnight
    //{date: @Date, selected: @boolean}
    nextWeek: function(date){
      if (!(date instanceof Date)){
        console.log("invalid Date input for Week.nextWeek: "+date);
      }
      var w = [];
      var d = new Date(date);
      var d_date = d.getDate();

      for (var i=0; i<7; i++){
        var _d = new Date(d);
        _d.setDate(d_date+i);
        var day_obj = {};
        day_obj.date = _d;

        if (JSON.stringify(day_obj.date) == JSON.stringify(d))
          day_obj.selected = true;
        else day_obj.selected = false;
        
        w[i] = day_obj;
      }
      return w;
    },

    // NOTE: I've standardized terminology in an unusual way
    // think from the perspective of weeks, not days
    // so, for example, 'this' Sunday is the Sunday in the current week. 
    thisSunday: function(date){
      if (!(date instanceof Date)){
        console.log("invalid Date input for Week.thisSunday: "+date);
      }

      var d = new Date(date);
      var sunday_offset = d.getDate() + ( 0 - d.getDay() );
      d.setDate(sunday_offset);
      return d;
    },

    // returns the Sunday from the following week
    nextSunday: function(date){
      if (!(date instanceof Date)){
        console.log("invalid Date input for Week.nextSunday: "+date);
      }

      var d = new Date(date);
      var next_sunday_offset = d.getDate() + ( 7 - d.getDay() );
      d.setDate(next_sunday_offset);
      return d;
    },

    // returns the Sunday from the preceding week
    lastSunday: function(date){
      if (!(date instanceof Date)){
        console.log("invalid Date input for Week.lastSunday: "+date);
      }
      var d = new Date(date); 
      var last_sunday_offset = d.getDate() + ( -7 - d.getDay() );
      d.setDate(last_sunday_offset);
      return d;
    },

    monthBounds: function(date){
      if (!(date instanceof Date)){
        console.log("invalid Date input for Week.monthBounds: "+date);
      }

      var d = new Date(date);
      var bounds = [];

      // first day of the month
      bounds[0] = new Date(d.getFullYear(), d.getMonth(), 1);
      // last day
      bounds[1] = new Date(d.getFullYear(), d.getMonth()+1, 0);
      return bounds;
    },

    datepickerBounds: function(date){
      if (!(date instanceof Date)){
        console.log("invalid Date input for Week.datepickerBounds, date: "+date);
      }

      var d = new Date( date );
      var bounds = [];

      var d0 = new Date(d.getFullYear(), d.getMonth(), 1);
      var d1 = new Date(d.getFullYear(), d.getMonth()+1, 0);

      var d0Adjusted = d0.getDate() + ( 0 - d0.getDay() );
      var d1Adjusted = d1.getDate() + ( 6 - d1.getDay() );

      d0.setDate( d0Adjusted );
      d1.setDate( d1Adjusted );

      bounds[0] = d0;
      bounds[1] = d1;

      return bounds;
    },

    isSameDay: function(d1, d2){
      if (!(d1 instanceof Date && d2 instanceof Date)){
        console.log("invalid Date input for Week.isSameDay, d1 and d2: "+d1+" "+d2);
      }

      var value = d1.getDate() === d2.getDate() && 
      d1.getMonth() === d2.getMonth() && 
      d1.getFullYear() === d2.getFullYear();

      return value;
    },

    daysInMonth: function(date){
      if (!(date instanceof Date)){
        console.log("invalid Date input for Week.daysInMonth: "+date);
      }

      var d = new Date(date);
      var bounds = monthBounds(d);
      var month = [];

      for (var i = 0, length = bounds[1].getDate(); i < length; i++) {
        var day = new Date(bounds[0]);
        day.setDate(i+1);
        month[i] = day;
      }

      return month;
    },

    parseDateISO8601: function(string){
      return new Date(+string.slice(0,4), +string.slice(5,7)-1, +string.slice(8,10));
    },

    // copied directly from angular-ui-bootstrap datepicker
    // just meant to synchronise with datepicker to pick out week rows
    getISO8601WeekNumber: function(date) {
      var checkDate = new Date(date);
      checkDate.setDate(checkDate.getDate() + 4 - (checkDate.getDay() || 7)); // Thursday
      var time = checkDate.getTime();
      checkDate.setMonth(0); // Compare with Jan 1
      checkDate.setDate(1);
      return Math.floor(Math.round((time - checkDate) / 86400000) / 7) + 1;
    }
  };
  return week_service;
});