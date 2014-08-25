
ooCalendar.directive('ooCalendarPickHandler', ['Picked', 'Visible',
  function (Picked, Visible) {
  return {
    link: function (scope, element, attrs) {
      scope.picked = Picked.data;
      scope.visible = Visible.data;

      // var scrol

      // on the other hand, in watchCollection, can I just assume that there'll be a 'picked' event?
      // 

      // make a qeue to hold whichever thing was last picked. Only obvious way to respect the most recent selection

      scope.$on('$allEventsLoaded', function(){
        var lastPick = Picked.lastPick;
        if (lastPick) {
         console.log('Events Loaded, scroll to:', lastPick);
        }
      });

      scope.$watch('visible.event', function(newValue) {
        console.log('VISIBLE:', Visible.getEvent());
      });

      scope.$watch('visible.day', function(newValue) {
        console.log('VISIBLE:', Visible.getDay());
      });

      scope.$watch('visible.week', function(newValue) {
        console.log('VISIBLE:', Visible.getWeek());
      });

      scope.$watch('picked.event', function(newValue) {
        console.log('Picked: ', newValue);
      });

      scope.$watch('picked.day', function(newValue) {
        console.log('Picked: ', newValue);
      });
    }
  };
}]);