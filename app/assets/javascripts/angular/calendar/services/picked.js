ooCalendar.factory('Picked', [ function () {
  var month, week, day, event;
  var lastPick;
  return {
    // get month() {
    //   return month;
    // },
    // set month(monthId) {
    //   month = lastPick = monthId;
    // },
    month: month,
    get week() {
      return week;
    },
    set week(weekId) {
      week = lastPick = weekId;
    },
    get day() {
      return day;
    },
    set day(dayId) {
      day = lastPick = dayId;
    },
    get event() {
      return event;
    },
    set event(eventId) {
      event = lastPick = eventId;
    },
    get lastPick() {
      return lastPick;
    }
  };
}]);