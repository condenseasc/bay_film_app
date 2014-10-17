'use strict';

ooCalendar.factory('EventFeed', ['$q', 'Event', 'Week', 'Name', 'eventApiTransformer',
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
            dates[i] = new Date(datesResource[i].time);
          }          
          return dates;
        });
      }
    };
    return EventFeed;
}]);