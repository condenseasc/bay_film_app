'use strict';
/* global angular */
var ooApp = angular.module('ooApp', [
  'ngRoute',
  'ngResource',
  'ngSanitize',
  'ooControllers',
  'ooDirectives',
  'ooFilters',
  'ooServices',
  'ui.bootstrap.position',
  'ui.bootstrap.datepicker',
  'ui.utils',
  'ui-templates',
  'duScroll',
  'mgcrea.ngStrap.affix',
  'mgcrea.ngStrap.helpers.dimensions']);


ooApp.config(['$routeProvider', function($routeProvider){
$routeProvider.
  when( '/', {
    templateUrl: '../assets/main/index.html',
    controller: 'CalendarCtrl'
  });
}]);