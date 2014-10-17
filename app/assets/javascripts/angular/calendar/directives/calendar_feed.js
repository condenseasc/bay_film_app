'use strict';
/*global ooCalendar, document, console*/

ooCalendar.directive('ooEventFeed', [ 'smoothScroll', 'Picked', function (smoothScroll, Picked) {
  return {
    restrict: 'E',
    // require: '^ooCalendarView',
    scope: {
      weeks: '='
    },
    templateUrl: 'template/calendar/directives/calendar_feed.html',
    link: function (scope, element, attrs) {
      scope.picked = Picked;

      scope.$watch('picked.day.selector', function (newValue, oldValue) {
        if (newValue) { 
          var el = document.getElementById(newValue);
          if (el) { 
            smoothScroll(el, { offset: -5 }); 
          }
        }
      });

      scope.$watch('picked.event.selector', function (newValue, oldValue) {
        console.log(newValue);
        if (newValue) { 
          var el = document.getElementById(newValue);
          console.log(el);
          if (el) {
            smoothScroll(el); 
          }
        }
      });

      scope.$on('$allEventsLoaded', function(event){
        // console.log('received loud and clear!');
        var lastPick = Picked.lastPick;
        console.log('lastPick', lastPick);

        if (lastPick) {
          var el = document.getElementById(lastPick);
          console.log(el);
          smoothScroll(el);
        }
        event.stopPropagation();
      });


    //   var options = {
    //     // duration: 700,
    //     easing: 'easeOutQuad',
    //     // offset: 120
    //   };

    //   scope.$watch("selectedDay", function (newValue) {
    //     var selected_element = document.getElementById("day-" + newValue.getDate());
    //     // element.find('#day-' + newValue.getDate()); // somehow this triggers constant scrolling to the top...
    //     if (selected_element) {
    //       smoothScroll(selected_element, options);
    //     }
    //   });
    }
  };
}]);