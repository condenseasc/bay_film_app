'use strict';

ooCalendar.directive('ooHighlightActiveWeek', [ function () {
  return {
    restrict: 'A',
    require: 'datepicker',
    scope: false,
    link: function (scope, element, attrs, DatepickerCtrl) {
      // console.log("highlight dir scope");
      // console.log(scope);

      attrs.$observe('refreshOn', function () {
        // console.log("highlight dir scope");
        // console.log(scope);
      });

      // // cf datepicker.js ln 200-219
      // function getISO8601WeekNumber(date) {
      //   var checkDate = new Date(date);
      //   checkDate.setDate(checkDate.getDate() + 4 - (checkDate.getDay() || 7)); // Thursday
      //   var time = checkDate.getTime();
      //   checkDate.setMonth(0); // Compare with Jan 1
      //   checkDate.setDate(1);
      //   return Math.floor(Math.round((time - checkDate) / 86400000) / 7) + 1;
      // }

      // attrs.$observe('refreshOn', function() {
      //   scope.ooWeekNumbers = [];
      //   var weekNumber = getISO8601WeekNumber( scope.rows[0][0].date ),
      //       numWeeks = scope.rows.length;
      //   while( scope.weekNumbers.push(weekNumber++) < numWeeks ) {}
      // });


    }
  };
}]);

