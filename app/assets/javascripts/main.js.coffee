#= require_self
#= require_tree ./controllers

@bayfilmApp = angular.module('bayfilmApp', [
  'ngRoute'
  'ngResource'
  'bayfilmControllers'])

# @bayfilmApp.config(['$routeProvider', ($routeProvider) ->
#   $routeProvider.
#     when('/events', {
#       templateUrl: '../assets/main/index.html'
#       controller: 'CalendarCtrl'
#     }).
#     otherwise({
#       redirectTo: '/events'
#       templateUrl: '../assets/main/index.html'
#       controller: 'CalendarCtrl'
#     })
# ])