
ooCalendar.directive('ooCalendarPickHandler', ['Picked', 'Visible',
  function (Picked, Visible) {
  return {
    link: function (scope, element, attrs) {
      scope.picked = Picked.data;
      scope.visible = Visible;

      // var scrol

      // on the other hand, in watchCollection, can I just assume that there'll be a 'picked' event?
      // 

      // make a qeue to hold whichever thing was last picked. Only obvious way to respect the most recent selection

      // scope.$on('$allEventsLoaded', function(){
      //   var lastPick = Picked.lastPick;
      //   if (lastPick) {
      //    console.log('Events Loaded, scroll to:', lastPick);
      //   }
      // });

      // scope.$watch('visible.day.selector', function(newValue) {
      //   console.log('VISIBLE:', Visible.day.selector);
      // });
      // scope.$watch('visible.day.date', function(newValue) {
      //   console.log('VISIBLE:', Visible.day.date);
      // });

      // scope.$watch('visible.week.id', function(newValue) {
      //   console.log('VISIBLE: week.id: ', Visible.week.id);
      // });

      // scope.$watch('visible.week.selector', function(newValue) {
      //   console.log('VISIBLE:', Visible.week.selector);
      // });

      // scope.$watch('visible.event.selector', function(newValue) {
      //   console.log('VISIBLE:', Visible.event.selector);
      // });

      // scope.$watch('visible.event.id', function(newValue) {
      //   console.log('VISIBLE: event.id: ', Visible.event.id);
      // });


      scope.$watch('picked.event', function(newValue) {
        console.log('Picked: ', newValue);
      });

      scope.$watch('picked.day', function(newValue) {
        console.log('Picked: ', newValue);
      });
    }
  };
}]);