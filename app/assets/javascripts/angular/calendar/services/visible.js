ooCalendar.factory('Visible', [ 'Name', function (Name) {
  var week, event;
  var dayDate, dayId;
  // var weekId, dayId, eventId;
  return {
    // week: {
    //   get id() {

    //   },
    //   set id() {

    //   },
    //   get date() {

    //   },
    //   set date() {

    //   }
    // },
    day: {
      get id() {
        return dayId;
      },
      set id(id) {
        dayDate = Name.id2Date(id);
        dayId = id;

      },
      get date() {
        return dayDate;
      },
      set date(date) {
        if (!(date instanceof Date)) { console.log('invalid input to Visible.day.date=, not a Date'); return; }
        dayDate = new Date(date.getFullYear(), date.getMonth(), date.getDay());
        dayId = Name.date2Id(dayDate);
      }
    },
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

      data: {
      week: week,
      // day: day,
      event: event
    },
    setWeek: function (weekId) {
      this.data.week = weekId;
    },
    // setDay: function (dayId) {
    //   this.data.day = dayId;
    // },
    setEvent: function (eventId) {
      this.data.event = eventId;
    },
    getWeek: function() {
      return this.data.week;
    },
    // getDay: function() {
    //   return this.data.day;
    // },
    getEvent: function() {
      return this.data.event;
    }


  };
}]);