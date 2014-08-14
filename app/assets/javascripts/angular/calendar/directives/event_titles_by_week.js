'use strict';
/*global ooCalendar, console, _*/

// Watches $scope.selected.week and $scope.weeks for changes
// Uses the selected week to copy the current week and send it to the template
// to be iterated over. So far no other processing of week data is in place,
// the template gets the whole bundle and pulls out titles, venues, dates, etc.
ooCalendar.directive('ooEventTitlesByWeek', ['$timeout', function ($timeout) {
  return {
    restrict: 'E',
    templateUrl: 'template/calendar/directives/event_titles_by_week.html',
    scope: {
      selectedWeekName: "@",
      loadedWeeks: "=",
      visible: '=',
      navTo: "&"
    },
    link: function (scope, element, attrs) {
      console.log('in title week list LINK');
      // scope.visible = {};
      // scope.visible.event = CalendarViewSpy.visible.event;
      // scope.$watch('visible.event', function (newEvent) {
      //   console.log('new event, from week list directive: ' + newEvent);
      //   element.find('list-' + newEvent).addClass('active');
      // });
    }

    // ,
    // link: {
    //   // so instead, have it repeat over all weeks objects, but
    //   // focus on the relevant week, the one currently 'on view'
    //   // the week directive should scroll automatically to the beginning of next week
    //   // when visible week changes. Otherwise it can have a simpler and separate mechanism,
    //   // if any, to keep the visible date in view in the sidebar
    //   // Maybe one that, when you scroll past to a movie not on the list
    //   // it catches up, scrolling to that day
    //   post: function (scope, element, attrs) {
    //     var currentWeek;
    //     attrs.$observe('selectedWeekName', function (newValue) {
    //       console.log(newValue);
    //       if (scope.loadedWeeks) {
    //         currentWeek = _.findWhere(scope.loadedWeeks, {page: newValue});
    //         scope.currentWeek = currentWeek;
    //       }
    //     });

    //     // A workaround. When selectWeek() is called, it takes a bit to load from the server.
    //     // This re-checks against selected.week whenever the week array updates.
    //     // At the moment this doesn't work because I disabled automatically calling selectWeek
    //     // on calling selectDay in favor of a general solution to loading the new position (scroll or w/e).
    //     scope.$watchCollection('loadedWeeks', function () {
    //       console.log("inside watchCollection");
    //       scope.currentWeek = _.findWhere(scope.loadedWeeks, { page: attrs.selectedWeekName });
    //     });
    //   }
    // }
  };
}]);