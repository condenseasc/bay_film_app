ooCalendar.factory('Picked', [ 'Name', function (Name) {
  var month;
  var lastPick;

  var weekId, weekSelector;
  var eventId, eventSelector;
  var dayDate, daySelector, dayId;


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


  return {
    month: month,
    day: {
      get selector() {
        return daySelector;
      },
      set selector(sel) {
        dayDate = Name.id2Date(sel);
        daySelector = sel;
        dayId = selectorToId(sel);
        lastPick = sel;
      },
      get date() {
        return dayDate;
      },
      set date(dt) {
        if (!(dt instanceof Date)) { 
          console.log('invalid input to Visible.day.date=, not a Date'); 
          return; 
        }

        // console.log('day.date= in Picked', dt);
        dayDate = new Date(dt.getFullYear(), dt.getMonth(), dt.getDate());
        dayId = Name.date(dayDate);
        daySelector = 'day-' + dayId;
        lastPick = daySelector;

        // console.log('day.date', dayDate, 'day.id', dayId, 'day.selector', daySelector, 'lastPick', lastPick);
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
        lastPick = daySelector;
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
          lastPick = weekSelector;
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
          lastPick = weekSelector;
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
          eventSelector = 'event-' + id;
          lastPick = eventSelector;
        }
      },
      set selector(sel) {
        console.log("event.selector called with ",sel);
        eventSelector = sel;
        lastPick = sel;

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
    get lastPick() {
      return lastPick;
    }









    // get month() {
    //   return month;
    // },
    // set month(monthId) {
    //   month = lastPick = monthId;
    // },
    // month: month,
    // get week() {
    //   return week;
    // },
    // set week(weekId) {
    //   week = lastPick = weekId;
    // },
    // get day() {
    //   return day;
    // },
    // set day(dayId) {
    //   day = lastPick = dayId;
    // },
    // get event() {
    //   return event;
    // },
    // set event(eventId) {
    //   event = lastPick = eventId;
    // },
    // get lastPick() {
    //   return lastPick;
    // }
  };
}]);