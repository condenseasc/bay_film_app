'use strict';
/*global angular, console, $, _, window*/

var ooDirectives = angular.module('ooDirectives', []);

ooDirectives

  .directive('ooRefreshDatepicker', [ function () {
    return {
      restrict: 'A',
      require: 'datepicker',
      link: {
        post: function (scope, element, attrs, DatepickerCtrl) {

          scope.$watch(function () {
            return DatepickerCtrl.currentCalendarDate.getMonth();
          },
            function () {
              var year = DatepickerCtrl.currentCalendarDate.getFullYear();
              var month = DatepickerCtrl.currentCalendarDate.getMonth();
              scope.loadActiveDates(new Date(year, month));
            });

          attrs.$observe('refreshOn', function () {
            DatepickerCtrl.refreshView();
          });
        }
      }
    };
  }])

  .directive('ooCheckWeekOnScroll', [ '$window', '$document', function ($window, $document) {
    return {
      restrict: 'A',
      link: function (scope, element, attrs) {
        var windowHeight, scrollTop, offset, dividingLine, weeks, weekHeight, scrolledWeek;

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

        angular.element($document).on('scroll', function () {
          var week = findCurrentWeek();
          if (week !== scope.selected.week) {
            scope.$apply(scope.selectWeek(week));
          }
        });
      }
    };
  }])

  .directive('ooHighlightSelectedWeek', [ function () {
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
  }])

  // Watches $scope.selected.week and $scope.weeks for changes
  // Uses the selected week to copy the current week and send it to the template
  // to be iterated over. So far no other processing of week data is in place,
  // the template gets the whole bundle and pulls out titles, venues, dates, etc.
  .directive('ooEventTitlesByWeek', [function () {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'template/ooEventTitlesByWeek.html',
      scope: {
        selectedWeekName: "@",
        loadedWeeks: "=",
      },
      link: {
        post: function (scope, element, attrs) {
          var currentWeek;
          attrs.$observe('selectedWeekName', function (newValue) {

            if (scope.loadedWeeks) {
              currentWeek = _.findWhere(scope.loadedWeeks, {page: newValue});
              scope.currentWeek = currentWeek;
            }
          });

          // A workaround. When selectWeek() is called, it takes a bit to load from the server.
          // This re-checks against selected.week whenever the week array updates.
          scope.$watchCollection('loadedWeeks', function () {
            scope.currentWeek = _.findWhere(scope.loadedWeeks, {page: scope.selectedWeekName });
          });
        }
      }
    };
  }]);