'use strict';
/*global ooCalendar, document, console, _*/

// Watches $scope.selected.week and $scope.weeks for changes
// Uses the selected week to copy the current week and send it to the template
// to be iterated over. So far no other processing of week data is in place,
// the template gets the whole bundle and pulls out titles, venues, dates, etc.
ooCalendar.directive(
  'pzTitlesNav', ['$timeout', '$document', 'Visible', 'smoothScrollingDiv', 
    function ($timeout, $document, Visible, smoothScrollingDiv) {
  return {
    restrict: 'E',
    templateUrl: 'template/calendar/directives/titles_nav.html',
    scope: {
      weeks: "="
      // selectedWeekName: "@",
      // loadedWeeks: "=",
      // visible: '='
      // navTo: "&"
    },
    link: function (scope, element, attrs) {
      scope.visible = Visible;
      scope.$watch('visible.week.selector', function (newValue, oldValue) {
        if (newValue === 0 || newValue){
          var el = document.getElementById('titles-nav-' + newValue);
          var scrollingDiv = document.querySelector('.titles-nav');
          // console.log("week element:", el, "titles-nav:", scrollingDiv, { offset: 250 });
          smoothScrollingDiv(el, scrollingDiv);
        }
      });
    }
  };
}]);