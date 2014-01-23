@bayfilmControllers.controller 'CalendarCtrl', ['$scope', '$resource' ($scope, $resource) ->
  Events = $resource('/api/events')
  $scope.events = Events.query
]