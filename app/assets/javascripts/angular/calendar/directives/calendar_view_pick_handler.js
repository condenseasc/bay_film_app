
ooCalendar.directive('ooCalendarViewPickHandler', ['CalendarViewSpy', function (CalendarViewSpy) {
  return {
    link: function (scope, element, attrs) {

      scope.$watch(function() {
        return CalendarViewSpy.getPickedEvent();
      },
      function(newValue) {
        console.log('WATCHED: ', newValue);

      });

      scope.$watch(function() {
        return CalendarViewSpy.picked.day;
      },
      function(newValue) {
        console.log('WATCHED: ', newValue);
      });
    }
  };
}]);