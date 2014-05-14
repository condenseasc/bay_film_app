'use strict';
/* global angular */
var ooApp = angular.module('ooApp', [
  'ooCalendar',
  'ngRoute']);


ooApp.config(['$routeProvider', function ($routeProvider) {
  $routeProvider.
    when('/', {
      templateUrl: '../assets/main/index.html',
      controller: 'CalendarCtrl'
    });
}]);