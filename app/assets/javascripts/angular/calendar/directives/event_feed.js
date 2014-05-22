'use strict';
/*global ooCalendar*/

ooCalendar.directive('ooEventFeed', [ function () {
  return {
    restrict: 'E',
    replace: true,
    scope: {
      weeks: '=',
      selected: '='
    },
    templateUrl: 'template/calendar/directives/event_feed.html'
  };
}]);