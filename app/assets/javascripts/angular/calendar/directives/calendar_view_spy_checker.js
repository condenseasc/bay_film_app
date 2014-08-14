'use strict';
/*global console, ooCalendar, window, angular, _, $*/

// every time we scroll, this directive checks the week-container visible in the event-feed,
// currently tuned to 0.25 * window height from the top, so a quarter of the way down.
// whichever week wins, gets selected using its page attribute, format yyyymmdd.
// it leaves selected.day well enough alone.
ooCalendar.directive('ooCalendarViewSpyChecker', [ '$window', '$document', '$timeout', 'Visible', 'Picked',
  function ($window, $document, $timeout, Visible, Picked) {
  return {
    restrict: 'EA',
    // controller: 'CalendarViewCtrl',
    // require: 'ooCalendarView',
    link: {
      // post because it relies on interpolated {{id's}} for scrolling
      // just the minor annoyance of 'no method x on "undefined"' on first load otherwise
      post: function (scope, element, attrs) {
        var windowHeight, scrollTop, dividingLine, heightRatio, weekId, dayId, eventId,
          weekChecker, dayChecker, eventChecker;
        heightRatio = angular.isDefined(attrs.heightRatio) ? attrs.heightRatio : 0.25;

        function makeVisibleElementChecker(top, bottom) {
          var elementTop = top, elementBottom = bottom;

          function setElementTop (newValue) {
            if (newValue) {
              elementTop = newValue;
            }
          }

          function setElementBottom (newValue) {
            if (newValue) {
              elementBottom = newValue;
            }
          }

          return function (referenceHeight, elementSelector) {
            // test whether we really need to do any calculations
            if (referenceHeight > elementBottom || referenceHeight < elementTop) {
              var offset, height, elements, scrolledElement;

              elements = angular.element(elementSelector);
              scrolledElement = _.find(elements, function (element) {
                offset = element.getBoundingClientRect().top + $document[0].body.scrollTop;
                height = element.offsetHeight;
                return offset <= referenceHeight && (offset + height) > referenceHeight;
              });

              setElementTop( offset );
              setElementBottom( offset + height );
              return angular.element(scrolledElement).attr('id');
            } 
          };
        }

        weekChecker = makeVisibleElementChecker(0, 0);
        dayChecker = makeVisibleElementChecker(0, 0);
        eventChecker = makeVisibleElementChecker(0, 0);


        angular.element($document).on('scroll', function () {
          windowHeight = $window.innerHeight;
          scrollTop = $window.pageYOffset;
          dividingLine = scrollTop + (windowHeight * heightRatio);

          weekId = weekChecker(dividingLine, ".week-container");
          dayId = dayChecker(dividingLine, "#" + (weekId || Visible.getWeek()) + " .day-container");
          eventId = eventChecker(dividingLine, "#" + (dayId || Visible.getDay()) + " .event-container");

          // only trigger a digest if they don't hold null, i.e. if they changed.
          if (weekId || dayId || eventId){
            scope.$apply(function() {
              if (weekId)  { Visible.setWeek(weekId);}
              if (eventId) { Visible.setEvent(eventId);}
              if (dayId)   { Visible.setDay(dayId);}
            });
          }
        });
      }
    }
  };
}]);