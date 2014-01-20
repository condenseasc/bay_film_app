@bayfilmControllers = angular.module('bayfilmControllers', [])

@bayfilmControllers.controller 'CalendarCtrl', ['$scope', ($scope) ->
  $scope.data = events: [{title:"Saturday Night Fever"}, {title:"Tony Manero"}]
]

# @CalendarCtrl = ('CalendarCtrl', ['$scope', ($scope) ->
# ])

# @CalendarCtrl = ($scope) ->
