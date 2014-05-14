'use strict';
/* global angular, console */
var ooControllers = angular.module('ooControllers', []);

ooControllers.controller('CalendarCtrl',
  ['$scope', '$q', '$location', '$timeout', '$anchorScroll', '$rootScope', '$window', '$document', 'Event', 'EventFeed', 'Week', 'Sort', 'Name',
    function ($scope, $q, $location, $timeout, $anchorScroll, $rootScope, $window, $document, Event, EventFeed, Week, Sort, Name) {

      // initialize everything
      $scope.weeks = [];
      $scope.selected = {};
      $scope.selectDay = selectDay; // only for testing. probably a better solution
      $scope.selectWeek = selectWeek;
      $scope.isWeekLoaded = isWeekLoaded; // ditto
      $scope.activeDates = [];
      $scope.activeDatesIndex = [];

      $scope.isDateDisabled = isDateDisabled;

      // load current week
      var d = new Date();
      selectDay(d);
      // angular.element($document).on('scroll', function () {
      //   console.log("Week on $scope: " + $scope.selected.week);
      // });

      $scope.$watch('selected.day', function (newValue) {
        var dateJustSelected = new Date(newValue);

        if (!(isWeekLoaded(dateJustSelected))) {
          loadWeek(dateJustSelected);
        }
        // selectWeek(Name.page(dateJustSelected));

        if (!(isMonthLoaded(dateJustSelected))) {
          $scope.loadActiveDates(dateJustSelected);
        }

        // var dayId = dt.getDate();
        $scope.scrollTo(dateJustSelected);
        // $location.hash(day);
      });

      function selectDay(date) {
        $scope.selected.day = date;
      }

      function selectWeek(page) {
        $scope.selected.week = page;
        console.log("selectWeek() called with ", page);
      }

      $scope.loadActiveDates = function (date) {
        EventFeed.activeDatesPromise(date).then(function (datesArray) {
          $scope.activeDates = datesArray;
          $scope.selected.month = date.toDateString();
        });
      };


      // for use with Angular-UI-Bootstrap Datepicker
      function isDateDisabled(date, mode) {
        // checks to see if this date is in the active dates array
        // if active, returns false for not-disabled, else, returns true for disabled
        if (mode === 'day') {
          var value = $scope.activeDates.some(function (element) {
            return Week.datesAreEqual(element, date);
          });

          return !value;
        }
        if (mode === 'month') { return false; }
        if (mode === 'year') { return false; }
      }

      function isMonthLoaded(date) {
        if ($scope.activeDates === undefined || $scope.activeDates.length === 0) { return false; }
        // grabs a day toward the middle of the month, 
        // since each month view overlaps with its neighbors
        var index = Math.floor($scope.activeDates.length / 2);
        var dt = new Date($scope.activeDates[index]);
        return dt.getMonth() === date.getMonth() && dt.getFullYear() === date.getFullYear();
      }


      $scope.scrollTo = function (id) {
        var dt = new Date(id);
        var dayId = dt.getDate();
        var old = $location.hash();
        $location.hash(dayId);
        $anchorScroll();
        //reset to old to keep any additional routing logic from kicking in
        $location.hash(old);
      };

      function isWeekLoaded(date) {
        var loaded = $scope.weeks.some(function (element, index, array) {
          var page_name = Name.page(date);
          return element.page === page_name;
        });
        return loaded;
      }

      // // Gives a promise to return date-sorted Event data
      // function asyncWeek(event_data){
      //   var deferred = $q.defer();
      //   deferred.resolve(makeDays(event_data));
      //   return deferred.promise;
      // }

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
        EventFeed.getWeekContaining(d).$promise.then(function (event_data) {
          var days = makeDays(event_data);
          var week = {
            page: Name.page(d),
            days: days
          };

          collatePages(week, 3);
        });
      }


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
      }

      $scope.nextWeek = function () {
        var next_sunday = Week.nextSunday($scope.selected.day);
        selectDay(next_sunday);
      };

      $scope.lastWeek = function () {
        var last_sunday = Week.lastSunday($scope.selected.day);
        selectDay(last_sunday);
      };
    }]);