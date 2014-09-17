'use strict';
/* global angular */
var ooApp = angular.module('ooApp', [
  'ooCalendar',
  'oo.calendar.templates',
  'ngRoute',
  'ui.scrollfix']);


ooApp.config(['$routeProvider', function ($routeProvider) {
  $routeProvider.
    when('/', {
      templateUrl: 'template/calendar/index.html',
      controller: 'CalendarCtrl'
    });
}]);