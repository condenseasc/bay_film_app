ooCalendar.directive('ooInnerLoadWatcher', [ function () {
  return {  
    restrict: 'A',
    link: function(scope, element, attrs) {
      if (scope.innerLast && scope.middleLast && scope.outerLast) {
        scope.$emit('$allEventsLoaded');
      }
    }
  };
}]);