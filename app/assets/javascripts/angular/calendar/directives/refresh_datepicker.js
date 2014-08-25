'use strict';
/*global ooCalendar*/

ooCalendar.directive('ooRefreshDatepicker', [ 'Picked', function (Picked) {
  return {
    restrict: 'A',
    require: 'datepicker',
    link: {
      post: function (scope, element, attrs, DatepickerCtrl) {
        scope.picked = Picked;
        scope.$watch(function () {
          return DatepickerCtrl.currentCalendarDate.getMonth();
        },
          function (newValue, oldValue) {
            // Test if listener is simply being initialized. 
            // Avoid since it hits the db frivolously.
            if (oldValue !== newValue) {
              var year = DatepickerCtrl.currentCalendarDate.getFullYear();
              var month = DatepickerCtrl.currentCalendarDate.getMonth();
              scope.loadActiveDates(new Date(year, month));
            }
        });
        // A way of hooking into CalendarCtrl's loading.
        // Ctrl picks the month on loading active dates.
        scope.$watch('picked.month', function () {
          DatepickerCtrl.refreshView();
        });
      }
    }
  };
}]);