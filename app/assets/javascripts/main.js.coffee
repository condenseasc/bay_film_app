#= require_self
#= require_tree ./controllers

@bayfilmApp = angular.module('bayfilmApp', [
  'ngRoute'
  'bayfilmControllers'])

@bayfilmApp.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.
    when('/events', {
      templateUrl: '../assets/main/index.html'
      controller: 'CalendarCtrl'
    }).
    otherwise({
      redirectTo: '/events'
      templateUrl: '../assets/main/index.html'
      controller: 'CalendarCtrl'
    })
])