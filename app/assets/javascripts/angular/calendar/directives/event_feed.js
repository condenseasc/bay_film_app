'use strict';
/*global ooCalendar*/

ooCalendar.directive('ooEventFeed', [ 'smoothScroll', function (smoothScroll) {
  return {
    restrict: 'E',
    replace: true,
    scope: {
      weeks: '=',
      selectedDay: '='
    },
    templateUrl: 'template/calendar/directives/event_feed.html',
    link: function (scope, element, attrs) {
      var options = {
        // duration: 700,
        easing: 'easeOutQuad',
        // offset: 120
      };

      scope.$watch("selectedDay", function (newValue) {
        var selected_element = document.getElementById("day-" + newValue.getDate());
        if (selected_element) {
          smoothScroll(selected_element, options);
        }
      });
    }
  };
}]);