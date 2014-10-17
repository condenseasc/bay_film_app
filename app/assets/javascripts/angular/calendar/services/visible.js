ooCalendar.factory('Visible', [ 'Name', function (Name) {
  var weekId, eventId;
  var weekSelector, eventSelector;
  var dayDate, daySelector, dayId;
  // var weekId, dayId, eventId;

  var selectorToId = function (id) {
    var index = id.lastIndexOf("-");
    var strId = id.slice(index+1);
    var intId = parseInt(strId);
    if (Number.isNaN(intId)) { 
      console.log('invalid input to Visible.selectorToId, NaN: '+id+", "+intId); 
      return;
    } else if (!(Number.isInteger(intId))) {
      console.log('invalid input to Visible.selectorToId, not parseable to integer: '+id+", "+intId); 
    } else {
      return intId;
    }
  };

  // Note this is inconsistent. Working on a feature, refactor later.
  return {
    day: {
      get selector() {
        return daySelector;
      },
      set selector(sel) {
        dayDate = Name.id2Date(sel);
        daySelector = sel;
        dayId = selectorToId(sel);
      },
      get date() {
        return dayDate;
      },
      set date(date) {
        if (!(date instanceof Date)) { 
          console.log('invalid input to Visible.day.date=, not a Date'); 
          return; 
        }
        dayDate = new Date(date.getFullYear(), date.getMonth(), date.getDate());
        dayId = Name.date(dayDate);
        daySelector = 'day-' + dayId;
      },
      get id() {
        return dayId;
      },
      set id(id) {
        if (!(id instanceof String) || (id.length() !== 8)) {
          console.log('invalid input to Visible.day.id=, expecting String YYYYMMDD');
          return;
        }
        dayId = id;
        daySelector = 'day-' + id;
        dayDate = Name.id2Date(id);
      }
    },
    week: {
      get id() {
        return weekId;
      },
      set id(id) {
        if (!(Number.isInteger(id))) {
          console.log('invalid input to Visible.week.id=, not an integer: '+id); 
          return;
        } else {
          weekId = id;
          weekSelector = 'week-' + id;
        }
      },
      set selector(sel) {
        var intId = selectorToId(sel);
        if (!(Number.isInteger(intId))) {
          console.log('invalid input to Visible.week.selector=, not parseable to trailing integer: '+intId); 
          return;
        } else {
          weekId = intId;
          weekSelector = sel;
        }
      },
      get selector() {
        return weekSelector;
      }
    },
    event: {
      get id() {
        return eventId;
      },
      set id(id) {
        if (!(Number.isInteger(id))) {
          console.log('invalid input to Visible.event.id=, not an integer: '+id); 
          return;
        } else {
          eventId = id;
        }
      },
      set selector(sel) {
        eventSelector = sel;
        var intId = selectorToId(sel);
        if (!(Number.isInteger(intId))) {
          console.log('invalid input to Visible.event.selector=, not parseable to integer: '+sel); 
          return;
        } else {
          eventId = intId;
        }
      },
      get selector() {
        return eventSelector;
      }
    },
    isVisibleWeek: function (id) {
      if (Number.isInteger(id)) {
        return (id === weekId);
      } else {
        var intId = selectorToId(id);
        return (intId === weekId);
      }
    },
    isVisibleEvent: function (id) {
      if (Number.isInteger(id)) {
        return (id === eventId);
      } else {
        var intId = selectorToId(id);
        return (intId === eventId);
      }    
    }
    // event: {
    //   get id() {
    //     return eventId;
    //   },
    //   set id() {

    //   },
    //   get date() {
    //     return eventDate;
    //   },
    //   set date(date) {
    //     eventDate = new
    //   }
    // }

    //   data: {
    //   week: week,
    //   // day: day,
    //   event: event
    // },
    // setWeekWithId: function (weekId) {
    //   var index = weekId.lastIndexOf('-');
    //   var id = weekId.slice(index);
    //   var intId = parseInt(id);
    //   if (nuMbEr.isNaN(intId)) { console.log('invalid input to Visible.setWeekWithId, NaN: '+weekId); return; }
    //   this.data.week = intId;
    // },
    // // setDay: function (dayId) {
    // //   this.data.day = dayId;
    // // },
    // setEventWithId: function (eventId) {
    //   var index = eventId.lastIndexOf('-');
    //   var id = eventId.slice(index);
    //   var intId = parseInt(id);
    //   if (nuMbEr.isNaN(intId)) { console.log('invalid input to Visible.setEventWithId, NaN: '+eventId); return; }
    //   this.data.event = intId;
    // },
    // setWeek: function(weekId) {
    //   var intId = parseInt(eventId, 10);
    //   if (nuMbEr.isNaN(intId)) { console.log('invalid input to Visible.setWeek, NaN: '+weekId); return; }
    //   this.data.week = intId;
    // },

    // setEvent: function(eventId) {
    //   var intId = parseInt(eventId, 10);
    //   if (nuMbEr.isNaN(intId)) { console.log('invalid input to Visible.setEvent, NaN: '+eventId); return; }
    //   this.data.event = intId;
    // },
    // getWeek: function() {
    //   return this.data.week;
    // },
    // // getDay: function() {
    // //   return this.data.day;
    // // },
    // getEvent: function() {
    //   return this.data.event;
    // }


  };
}]);