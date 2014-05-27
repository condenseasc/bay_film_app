'use strict';
/*global ooCalendar, window*/

// every time we scroll, this directive checks the week-container visible in the event-feed,
// currently tuned to 0.25 * window height from the top, so a quarter of the way down.
// whichever week wins, gets selected using its page attribute, format yyyymmdd.
// it leaves selected.day well enough alone.
ooCalendar.directive('ooCalendarView', [ '$window', '$document', function ($window, $document) {
  return {
    restrict: 'E',
    controller: 'CalendarViewCtrl',
    require: 'ooCalendarView',
    link: {
      // post because it relies on interpolated {{id's}} for scrolling
      // just the minor annoyance of 'no method x on "undefined"' otherwise
      post: function (scope, element, attrs, CalendarViewCtrl) {
        var heightRatio = angular.isDefined(attrs.heightRatio) ? attrs.heightRatio : 0.25;

        function findVisible(referenceHeight, css) {
          var elements = angular.element(css);
          var scrolledElement = _.find(elements, function (element) {
            var offset = $(element).offset().top;
            var height = $(element).height();
            return offset <= referenceHeight && (offset + height) > referenceHeight;
          });
          return angular.element(scrolledElement).attr('id');
        }

        angular.element($document).on('scroll', function () {
          var weekId, dayId, eventId, weekName, windowHeight, scrollTop, dividingLine;

          windowHeight = $(window).height();
          scrollTop = $(window).scrollTop();
          dividingLine = scrollTop + (windowHeight * heightRatio);

          weekId = findVisible(dividingLine, ".week-container");

          if (CalendarViewCtrl.getVisibleWeek !== weekId) {
            CalendarViewCtrl.updateVisibleWeek(weekId);
            dayId = findVisible(dividingLine, "#" + weekId + " .day-container");

            if (CalendarViewCtrl.getVisibleDay !== dayId) {
              CalendarViewCtrl.updateVisibleDay(dayId);
              eventId = findVisible(dividingLine, "#" + dayId + " .event-container");

              if (CalendarViewCtrl.getVisibleEvent !== eventId) {
                CalendarViewCtrl.updateVisibleEvent(eventId);
              }
            }
          }
        });
      }
    }
  };
}]);