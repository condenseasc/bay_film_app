// 'use strict';
// /*global ooCalendar, console*/

// ooCalendar.constant('scrollConfig', {
//   // 'easeInQuad'
//   // 'easeOutQuad'
//   // 'easeInOutQuad'
//   // 'easeInCubic'
//   // 'easeOutCubic'
//   // 'easeInOutCubic'
//   // 'easeInQuart'
//   // 'easeOutQuart'
//   // 'easeInOutQuart'
//   // 'easeInQuint'
//   // 'easeOutQuint'
//   // 'easeInOutQuint'
//   easing: 'easeOutQuart',
//   duration: 800,
//   offset: 0
// });

ooCalendar.controller('CalendarViewCtrl', ['$scope', 'Picked',
  function ($scope, Picked) {

  // Configuration attributes
  // angular.forEach(['formatDay', 'formatMonth', 'formatYear', 'formatDayHeader', 'formatDayTitle', 'formatMonthTitle',
  //                  'minMode', 'maxMode', 'showWeeks', 'startingDay', 'yearRange'], function( key, index ) {
  //   self[key] = angular.isDefined($attrs[key]) ? (index < 8 ? $interpolate($attrs[key])($scope.$parent) : $scope.$parent.$eval($attrs[key])) : datepickerConfig[key];
  // });

    $scope.picked = Picked;

    this.pickWeek = function (weekId) {
      Picked.week = weekId;
      // Picked.pickWeek(weekId);
    };

    this.pickDay = function (dayId) {
      Picked.day = dayId;
      // Picked.pickDay(dayId);
    };

    this.pickEvent = function (eventId) {
      Picked.event = eventId;
      // Picked.pickEvent(eventId);
    };

    this.getPickedDay = function () {
      return Picked.day;
      // return Picked.getDay();
    };
  }]);