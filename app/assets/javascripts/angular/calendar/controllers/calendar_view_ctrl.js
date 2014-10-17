// 'use strict';
// /*global ooCalendar, console*/

ooCalendar.controller('CalendarViewCtrl', ['$scope', 'Picked', 'Visible', 'Name',
  function ($scope, Picked, Visible, Name) {

  // Configuration attributes
  // angular.forEach(['formatDay', 'formatMonth', 'formatYear', 'formatDayHeader', 'formatDayTitle', 'formatMonthTitle',
  //                  'minMode', 'maxMode', 'showWeeks', 'startingDay', 'yearRange'], function( key, index ) {
  //   self[key] = angular.isDefined($attrs[key]) ? (index < 8 ? $interpolate($attrs[key])($scope.$parent) : $scope.$parent.$eval($attrs[key])) : datepickerConfig[key];
  // });

    this.picked = Picked;
    $scope.visible = Visible;

    this.isVisibleDay = function(date) {
      if (!(date instanceof Date && Visible.day.date instanceof Date)) {
        return false;
      } else if ( this.compareDates(date, Visible.day.date ) === 0) {
        return true;
      } else {
        return false;
      }
    };

    this.pickEvent = function(id) {
      $scope.picked.event = id;
    };

    this.pickDay = function(id) {
      var date = new Date(id);
      $scope.picked.day = date;
    };

    this.isVisibleEvent = function(id) {
      return Visible.isVisibleEvent(id);
    };

    this.isVisibleWeek = function(id) {
      return Visible.isVisibleWeek(id);
    };

    this.dayId = function (date) {
      return Name.date(date);
    };

    this.compareDates = function (date1, date2) {
      return (new Date( date1.getFullYear(), date1.getMonth(), date1.getDate() ) - new Date( date2.getFullYear(), date2.getMonth(), date2.getDate() ) );
    };

    // this.pickWeek = function (weekId) {
    //   Picked.week = weekId;
    //   // Picked.pickWeek(weekId);
    // };

    // this.pickDay = function (dayId) {
    //   Picked.day = dayId;
    //   // Picked.pickDay(dayId);
    // };

    // this.pickEvent = function (eventId) {
    //   Picked.event = eventId;
    //   // Picked.pickEvent(eventId);
    // };

    // this.getPickedDay = function () {
    //   return Picked.day;
    //   // return Picked.getDay();
    // };

    // this.isPickedDay = function () {

    // }
  }]);