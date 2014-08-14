ooCalendar.factory('Visible', [ function () {
  var week, day, event;
  return {
      data: {
      week: week,
      day: day,
      event: event
    },
    setWeek: function (weekId) {
      this.data.week = weekId;
    },
    setDay: function (dayId) {
      this.data.day = dayId;
    },
    setEvent: function (eventId) {
      this.data.event = eventId;
    },
    getWeek: function() {
      return this.data.week;
    },
    getDay: function() {
      return this.data.day;
    },
    getEvent: function() {
      return this.data.event;
    }
  };
}]);