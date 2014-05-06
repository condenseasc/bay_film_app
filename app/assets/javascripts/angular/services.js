var ooServices = angular.module('ooServices', []);

ooServices.factory('Week', function(){
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

    datesAreEqual: function(d1, d2){
      if (!(d1 instanceof Date && d2 instanceof Date)){
        console.log("invalid Date input for Week.datesAreEqual, d1 and d2: "+d1+" "+d2);
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

ooServices.factory('Name', [ 'Week', function(Week){
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

// ended up with a different function
// read the other one and figure it out!
ooServices.factory('Sort', [ function(){
  var Sort = {
    uniqueDates: function(data){
      // console.log("input to uniqueDates(): "+JSON.stringify(data));
      if (typeof data === 'undefined') {return [];}
      var array = data.map(function(element, index, array){
        return {time: new Date(element.time).toDateString()};
      });

      // for (var i = array.length - 1; i >= 0; i--) {
      //   array[i].time = new Date(array[i].time).toDateString();
      // }
      // console.log("input to unique() from uniqueDates(): "+array);
      // console.log("data at input to unique() from uniqueDates(): "+JSON.stringify(data));


      var result = this.unique(array, 'time');
      // console.log("returned from unique(): "+result);
      result.forEach(function(element, index, array){
        array[index] = new Date(element);
      });
      // console.log("result of uniqueDates"+result);

      return result;
    },
    unique: function(data, key){
      var result = [];
      for (var i = 0, length = data.length; i < length; i++) {
        var value = data[i][key];
        if (result.indexOf(value) == -1)
          result.push(value);
      }
      return result;
    }
  };
  return Sort;
}]);

ooServices.factory('Event', ['$resource', 'eventApiTransformer',
  function($resource, eventApiTransformer) {
    return $resource(
      "api/events/:id", 
      {id: "@id"}
      // ,
      // {query: {
      //   method:'GET',
      //   isArray: true,
      //   transformResponse: eventApiTransformer
      // }}
    ); 
}]);


ooServices.factory('EventFeed', ['$q', 'Event', 'Week', 'Name', 'eventApiTransformer',
  function($q, Event, Week, Name, eventApiTransformer) {
    var firstDate = {};
    var lastDate = {};
    var days = [];
    var EventFeed = {
      getEventsRange: function(from, to){
        firstDate = from;
        lastDate = to;
        return Event.query({from: Name.date(from), to: Name.date(to)});
      },
      getWeekContaining: function(date){
        var w = Week.bounds(date);
        firstDate = w[0];
        lastDate = w[1];
        return Event.query({page: Name.date(w[0])});
      },
      // returns false if first and last dates are blank objects
      // good for initializing
      isInRange: function(date){
        var d = new Date(date);
        return (d >= firstDate && d <= lastDate);
      },

      activeDatesPromise: function(date){
        var deferred = $q.defer();
        deferred.resolve( this.getActiveDates( date ) );
        return deferred.promise;
      },

      getActiveDates: function(date){
        var m = Week.datepickerBounds(date);

        return Event.query({ active_dates:true, from: Name.date(m[0]), to: Name.date(m[1]) })
        .$promise.then( function(datesResource) {
        
          var dates = [];

          for (var i = 0, length = datesResource.length; i < length; i++) {
            dates[i] = Week.parseDateISO8601(datesResource[i].date);
          }
          
          return dates;
        });
      }
    };
    return EventFeed;
}]);

ooServices.factory('eventApiTransformer', function() {
  return function(data, headersGetter) {
    // console.log(data);
    var events = JSON.parse(data);
    if(events.length){
      var compDate = new Date(events[0].time);
      events[0].newDay = true;
  
      for (var i = 1, length = events.length; i < length; i++) {
        var eventTime = new Date(events[i].time);
        if (eventTime.getDate() != compDate.getDate()){
          events[i].newDay = true; 
          compDate = new Date(events[i].time);
        }
        else
          events[i].newDay = false;
      }
    }
    return events;
  };
});