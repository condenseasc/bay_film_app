'use strict';

ooCalendar.factory('eventApiTransformer', function() {
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