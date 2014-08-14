ooCalendar.factory('Picked', [ function () {
  var week, day, event;
  var lastPick;
  return {
    data: {
      week: week,
      day: day,
      event: event
    },
    setLastPick: function (id) {
      lastPick = id;
    },
    getLastPick: function() {
      return lastPick;
    },
    getWeek: function() {
      return this.data.week;
    },
    getDay: function() {
      return this.data.day;
    },
    getEvent: function() {
      return this.data.event;
    },
    pickWeek: function (weekId) {
      this.data.week = weekId;
      this.setLastPick(weekId);
    },
    pickDay: function (dayId) {
      this.data.day = dayId;
      this.setLastPick(dayId);
    },
    pickEvent: function (eventId) {
      this.data.event = eventId;
      this.setLastPick(eventId);
    }
  };
}]);