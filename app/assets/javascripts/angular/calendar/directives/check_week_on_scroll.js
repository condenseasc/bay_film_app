'use strict';

// every time we scroll, this directive checks the week-container visible in the event-feed,
// currently tuned to 0.3 * window height from the top, so a third of the way down.
// whichever week wins, gets selected using its page attribute, format yyyymmdd.
// it leaves selected.day well enough alone.
ooCalendar.directive('ooCheckWeekOnScroll', [ '$window', '$document', function ($window, $document) {
  return {
    restrict: 'A',
    link: function (scope, element, attrs) {
      var windowHeight, scrollTop, offset, dividingLine, weeks, weekHeight, scrolledWeek;

      // figures out what week-container is on view, returns that week's
      // id, which is set to its page attribute with format yyyymmdd
      function findCurrentWeek() {
        windowHeight = $(window).height();
        scrollTop = $(window).scrollTop();
        dividingLine = scrollTop + (windowHeight * 0.3);

        weeks = angular.element(".week-container");
        scrolledWeek = _.find(weeks, function (week) {
          offset = $(week).offset().top;
          weekHeight = $(week).height();

          return offset <= dividingLine && (offset + weekHeight) > dividingLine;
        });

        return angular.element(scrolledWeek).attr('id');
      }

      // selects the visible week, if it isn't already
      angular.element($document).on('scroll', function () {
        var week = findCurrentWeek();
        if (week !== scope.selected.week) {
          scope.$apply(scope.selectWeek(week));
        }
      });
    }
  };
}]);