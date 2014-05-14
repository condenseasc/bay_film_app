'use strict';
/*global ooCalendar*/

ooCalendar.directive('ooRefreshDatepicker', [ function () {
  return {
    restrict: 'A',
    require: 'datepicker',
    link: {
      post: function (scope, element, attrs, DatepickerCtrl) {

        scope.$watch(function () {
          return DatepickerCtrl.currentCalendarDate.getMonth();
        },
          function () {
            var year = DatepickerCtrl.currentCalendarDate.getFullYear();
            var month = DatepickerCtrl.currentCalendarDate.getMonth();
            scope.loadActiveDates(new Date(year, month));
          });

        attrs.$observe('refreshOn', function () {
          DatepickerCtrl.refreshView();
        });
      }
    }
  };
}]);