'use strict';
/*global console, ooCalendar, window, angular, _, $*/

// every time we scroll, this directive checks the week-container visible in the event-feed,
// currently tuned to 0.25 * window height from the top, so a quarter of the way down.
// whichever week wins, gets selected using its page attribute, format yyyymmdd.
// it leaves selected.day well enough alone.
ooCalendar.directive('ooCalendarViewSpyChecker', [ '$window', '$document', '$timeout', 'CalendarViewSpy', 
  function ($window, $document, $timeout, CalendarViewSpy) {
  return {
    restrict: 'EA',
    // controller: 'CalendarViewCtrl',
    // require: 'ooCalendarView',
    link: {
      // post because it relies on interpolated {{id's}} for scrolling
      // just the minor annoyance of 'no method x on "undefined"' on first load otherwise
      post: function (scope, element, attrs) {
        console.log('IN SPY LINK');

        var windowHeight, scrollTop, dividingLine;
        var heightRatio = angular.isDefined(attrs.heightRatio) ? attrs.heightRatio : 0.25;

        function findVisible(referenceHeight, elementSelector) {
          var elements = angular.element(elementSelector);
          var scrolledElement = _.find(elements, function (element) {
            var offset = $(element).offset().top;
            // var offset = element.getBoundingClientRect().top + document.body.scrollTop;
            var height = $(element).height();
            return offset <= referenceHeight && (offset + height) > referenceHeight;
          });
          return angular.element(scrolledElement).attr('id');
        }

        // var recalculateLine = function () {
        // };

        // recalculateLine();

        // $(window).bind('resize', $timeout(recalculateLine(), 50));

        angular.element($document).on('scroll', function () {
          windowHeight = $(window).height();
          scrollTop = $(window).scrollTop();
          dividingLine = scrollTop + (windowHeight * heightRatio);


          console.log('spy: scrolled');
          var weekId, dayId, eventId, weekName;
          weekId = findVisible(dividingLine, ".week-container");

          if (weekId && (CalendarViewSpy.getVisibleWeek() !== weekId)) {
            CalendarViewSpy.updateVisibleWeek(weekId);
            console.log('spy: v.week set to ', weekId);
            dayId = findVisible(dividingLine, "#" + weekId + " .day-container");

            if (dayId && (CalendarViewSpy.getVisibleDay() !== dayId)) {
              console.log(dayId, CalendarViewSpy.getVisibleDay(), (CalendarViewSpy.getVisibleDay() !== dayId));
              console.log(CalendarViewSpy.visible);
              CalendarViewSpy.updateVisibleDay(dayId);
              console.log('spy: v.day set to ', dayId);
              eventId = findVisible(dividingLine, "#" + dayId + " .event-container");

              if (eventId && (CalendarViewSpy.getVisibleEvent() !== eventId)) {
                CalendarViewSpy.updateVisibleEvent(eventId);
                console.log('spy: v.event set to ', eventId);
              }
            }
            scope.$apply();
          }


          // console.log('visible week: ', CalendarViewCtrl.getVisibleWeek());
          // console.log('visible day: ', CalendarViewCtrl.getVisibleDay());
          // console.log('visible event: ', CalendarViewCtrl.getVisibleEvent());
        });
      }
    }
  };
}]);