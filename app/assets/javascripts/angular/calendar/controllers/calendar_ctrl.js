'use strict';
/* global angular, console, ooCalendar*/

ooCalendar.controller('CalendarCtrl',
  ['$scope', '$q', '$location', '$timeout', '$rootScope', 'Event', 'EventFeed', 'Week', 'Name', 'Picked',
    function ($scope, $q, $location, $timeout, $rootScope, Event, EventFeed, Week, Name, Picked) {


      // initialize everything
      $scope.weeks = [];
      $scope.isWeekLoaded = isWeekLoaded; // just for testing.
      $scope.activeDates = [];
      $scope.activeDatesIndex = [];
      $scope.picked = Picked;

      var weeksLoaded = false;

      // load current week
      var d = new Date();
      // var weekCollater = makeWeekManager(d, 3);
      Picked.day = d;

      $scope.$watch('picked.day', function (newDay) {
        var date = new Date(newDay);
        if (!isWeekLoaded(  date )) { loadWeek(date); }
        if (!isMonthLoaded( date )) { $scope.loadActiveDates(date); }
        // var week = Name.week(date);
        // if (week !== $scope.picked.week) {
        //   Picked.week = week;
        // }
      });

      function isWeekLoaded(date) {
        var loaded = $scope.weeks.some(function (element, index, array) {
          var page_name = Name.week(date);
          return element.page === page_name;
        });
        return loaded;
      }
      // Id.week()

        // Recursive timeout to check if week is done loading
        // before scrolling to its id.
        // Not totally clean, on actual load it shifts the whole
        // column, then the scroll is triggered, kinda spastic looking.

        // if (weeksLoaded) {
        //   $scope.scrollTo(dayIdFromDate(dateJustSelected));
        // } else {
        //   $timeout(function scrollToWeekOnLoad() {
        //     if (weeksLoaded) {
        //       $scope.scrollTo(dayIdFromDate(dateJustSelected));
        //     } else {
        //       $timeout(function () { scrollToWeekOnLoad(); }, 500);
        //     }
        //   }, 500);
        // }
      // });


      $scope.loadActiveDates = function (date) {
        EventFeed.activeDatesPromise(date).then(function (datesArray) {
          $scope.activeDates = datesArray;
          $scope.picked.month = date.toDateString();
        });
      };


      // for use with Angular-UI-Bootstrap Datepicker
      $scope.isDateDisabled = function (date, mode) {
        // checks to see if this date is in the active dates array
        // if active, returns false for not-disabled, else, returns true for disabled
        if (mode === 'day') {
          var value = $scope.activeDates.some(function (element) {
            return Week.isSameDay(element, date);
          });

          return !value;
        }
        if (mode === 'month') { return false; }
        if (mode === 'year') { return false; }
      };

      function isMonthLoaded(date) {
        if ($scope.activeDates === undefined || $scope.activeDates.length === 0) { return false; }
        // grabs a day toward the middle of the month, 
        // since each month view overlaps with its neighbors
        var index = Math.floor($scope.activeDates.length / 2);
        var dt = new Date($scope.activeDates[index]);
        return dt.getMonth() === date.getMonth() && dt.getFullYear() === date.getFullYear();
      }

      function dayIdFromDate(date) {
        var dt = new Date(date);
        var dayId = "day-" + dt.getDate();
        return dayId;
      }

      function weekIdFromDate(date) {
        var dt = new Date(date);
        var weekId = "week-" + Name.week(dt);
        return weekId;
      }


      // the algorithm used to resolve asyncWeek, sorting Event resource
      // data into date-sorted days
      function makeDays(collection) {
        var i, length, event, days, day, date, date_string, date_grouping;
        days = [];
        date_grouping = '_INVALID_DATE_';

        // make an array of days, each with an array of matching events
        for (i = 0, length = collection.length; i < length; i++) {
          event = collection[i];
          date = new Date(event.time);
          date_string = Name.date(date);

          // check if it's a new day
          if (date_string !== date_grouping) {
            date_grouping = date_string;

            day = {
              date: date,
              events: []
            };

            days.push(day);
          }
          day.events.push(event);
        }

        return days;
      }

      // handles the async flow between EventFeed and asyncWeek, finally
      // passing the sorted events to the view logic in collatePages
      function loadWeek(d) {
        weeksLoaded = false;

        EventFeed.getWeekContaining(d).$promise.then(function (event_data) {
          var days = makeDays(event_data);
          var week = {
            page: Name.week(d),
            days: days
          };

          collatePages(week, 3);
        });
      }

      // // initialize with date, since we always start with the present...
      // // when might this fail?
      // function makeWeekManager (max_weeks, date) {
      //   var week_ids = [];
      //   var adjacent_ids = [];

      //   function setAdjacentIds (weekId) {
      //     // to date
      //     // to next sunday
      //     // to previous
      //   }



      //   return function (week) {
      //     exceeds_max = ($scope.weeks.length >= max-1) ? true : false;
      //     // if ($scope.weeks.length >= max-1) {exceeds_max = true} else 
      //     switch (week.id) {
      //       case week_ids[0]:
      //         $scope.weeks.unshift(week);
      //         if (exceeds_max) { $scope.weeks.pop(); }
      //         break;
      //       case week_ids[1]:
      //         $scope.weeks.push(week);
      //         if (exceeds_max) { $scope.weeks.shift(); }
      //         break;
      //     }
      //     setAdjacentIds()
      //   }
      // }


      // 
      function collatePages(week, max_pages) {
        var new_page, loaded_pages, previous_page, next_page, exceeds_max;
        if ($scope.weeks.length >= max_pages) { exceeds_max = true; }

        loaded_pages = $scope.weeks.map(function (element) {
          // map to first sundays as Date objects
          return Name.toDate(element.page);
        });

        // check for empty array
        if (loaded_pages.length === 0) {
          $scope.weeks.push(week);
          return;
        }

        previous_page = Name.date(Week.lastSunday(loaded_pages[0]));
        next_page = Name.date(Week.nextSunday(loaded_pages[loaded_pages.length - 1]));

        if (week.page === previous_page) {
          $scope.weeks.unshift(week);
          if (exceeds_max) { $scope.weeks.pop(); }
        } else if (week.page === next_page) {
          $scope.weeks.push(week);
          if (exceeds_max) { $scope.weeks.shift(); }
        } else {
          $scope.weeks = [];
          $scope.weeks.push(week);
        }
        // console.log("setting weeksLoaded to true");
        weeksLoaded = true;
      }

      // $scope.nextWeek = function () {
      //   var next_sunday = Week.nextSunday($scope.selected.day);
      //   selectDay(next_sunday);
      // };

      // $scope.lastWeek = function () {
      //   var last_sunday = Week.lastSunday($scope.selected.day);
      //   selectDay(last_sunday);
      // };
    }]);