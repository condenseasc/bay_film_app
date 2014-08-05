ooCalendar.factory('CalendarViewSpy', [ function () {
  var visibleWeekId, visibleEventId, visibleDayId, pickedWeekId, pickedDayId, pickedEventId = '';
  return {
    visible: {
      week: visibleWeekId,
      day: visibleDayId,
      event: visibleEventId
    },
    picked: {
      day: pickedDayId,
      event: pickedEventId
    },
    updateVisibleWeek: function (weekId) {
      this.visible.week = weekId;
      // visibleWeekId = weekId;
    },
    updateVisibleDay: function (dayId) {
      this.visible.day = dayId;
      // visibleDayId = dayId;
    },
    updateVisibleEvent: function (eventId) {
      this.visible.event = eventId;
      // visibleEventId = eventId;
    },
    // pickWeek: function (weekId) {
    //   this.picked.week = weekId;
    //   // pickedWeekId = weekId;
    // },
    pickDay: function (dayId) {
      console.log('pickDay called with ', dayId);
      this.picked.day = dayId;
      // console.log('picked.day value: ', this.picked.day);
      console.log('Picked: ', this.picked);
      // pickedDayId = dayId;
    },
    pickEvent: function (eventId) {
      console.log('pickEvent called with ', eventId);
      this.picked.event = eventId;
      console.log('Picked: ', this.picked);
    },
    getVisibleWeek: function() {
      return this.visible.week;
      // return visibleWeekId;
      // this.visible.week;
    },
    getVisibleDay: function() {
      // return visibleDayId;
      return this.visible.day;
    },
    getVisibleEvent: function() {
      // return visibleEventId;
      return this.visible.event;
    },
    // getPickedWeek: function() {
    //   // return pickedWeekId;
    //   return this.picked.week;
    // },
    getPickedDay: function() {
      // return pickedDayId;
      return this.picked.day;
    },
    getPickedEvent: function() {
      // return pickedEventId;
      return this.picked.event;
    }
  };
}]);