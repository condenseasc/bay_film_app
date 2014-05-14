'use strict';
/*global ooCalendar*/

// Watches $scope.selected.week and $scope.weeks for changes
// Uses the selected week to copy the current week and send it to the template
// to be iterated over. So far no other processing of week data is in place,
// the template gets the whole bundle and pulls out titles, venues, dates, etc.
ooCalendar.directive('ooEventTitlesByWeek', [function () {
  return {
    restrict: 'E',
    replace: true,
    templateUrl: 'template/ooEventTitlesByWeek.html',
    scope: {
      selectedWeekName: "@",
      loadedWeeks: "=",
    },
    link: {
      post: function (scope, element, attrs) {
        var currentWeek;
        attrs.$observe('selectedWeekName', function (newValue) {
          console.log(newValue);
          if (scope.loadedWeeks) {
            currentWeek = _.findWhere(scope.loadedWeeks, {page: newValue});
            scope.currentWeek = currentWeek;
          }
        });

        // A workaround. When selectWeek() is called, it takes a bit to load from the server.
        // This re-checks against selected.week whenever the week array updates.
        scope.$watchCollection('loadedWeeks', function () {
          console.log("inside watchCollection");
          // console.log(scope);
          // console.log(attrs);
          scope.currentWeek = _.findWhere(scope.loadedWeeks, { page: attrs.selectedWeekName });
        });
      }
    }
  };
}]);