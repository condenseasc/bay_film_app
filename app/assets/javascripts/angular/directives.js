'use strict';
/*global angular, console, $, _, window*/

var ooDirectives = angular.module('ooDirectives', []);

ooDirectives
.directive('ooEventsContainer', ['dateFilter', 'EventFeed', 
  function(dateFilter, EventFeed) {
  return {
    restrict: 'E',
    scope: true,
    link: function(scope, element, attrs){
      // console.log("parent");
      // console.log(scope);
      // console.log("selected_day: "+ scope.selected_day);
      // console.log("after parent");
      // element.text(dateFilter(scope.selected_day, 'MMM d h:mm a'));
    },
    // template: '<input type="text" ng-model="selected_day"><oo-events-day-titles day="{{selected_day}}"></oo-events-day-titles>'
  };
}])

.directive('ooEventsDayButton', ['dateFilter', 'Weekdays', function(dateFilter, Weekdays){
  return {
    restrict: 'A',
    scope: true,
    link: function(scope, element, attrs){
      //when it's pressed, tell directive to change the day
      //when a day is broadcast, change the selected button
      // // does that mean i need another controller?!
      
    }
  };
}])

.directive('ooEventsDayTitles', ['dateFilter', function(dateFilter){
  return {
    restrict: 'E',
    scope: true,
    // templateUrl: 'oo-events-day-titles.html'
    template: '<div>{{selected_day | date:"MMM d h:mm a"}} as per this dir</div><div>from ooEventsDayTitles</div>',
    link: function(scope, element, attrs){
      // var day = ctrl.selected_day.date;
      // day.setDate(10);
      // console.log("selected_day value: " + dateFilter(scope.selected_day.date, "MMM d h:mm a")); 

      // console.log("child");
      // console.log(scope); 
      // console.log(scope.day);
      // console.log("after child");


      // $scope.$watch('selected_day', function(date){
      //   updateDate(date);
      // });

      // function updateDate(date){
      //   attrs.day = date;
      // }
    }
  };
}])

// .directive('dayId', ['dateFilter', function(dateFilter){
//   return {
//     restrict: 'A',
//     scope: true,
//     // templateUrl: 'oo-events-day-titles.html'
//     template: '<div>{{selected_day | date:"MMM d h:mm a"}} as per this dir</div><div>from ooEventsDayTitles</div>',
//     link: function(scope, element, attrs){

//     }
//   };
// }]);

.directive('ooRefreshDatepicker', [ function(){
  return {
    restrict: 'A',
    require: 'datepicker',
    link: {
      post: function(scope, element, attrs, DatepickerCtrl){

        scope.$watch( function() {
          return DatepickerCtrl.currentCalendarDate.getMonth();
        },
        function(newValue, oldValue) {
          var year = DatepickerCtrl.currentCalendarDate.getFullYear();
          var month = DatepickerCtrl.currentCalendarDate.getMonth();
          scope.loadActiveDates( new Date( year, month ) );
        });

        attrs.$observe('refreshOn', function() {
          // console.log("inside directive refresh watch");
          // console.log("refreshOn: "+attrs.refreshOn);
          // console.log("ctrl inside directive refresh observe: ");
          // console.log(DatepickerCtrl);
          // console.log("datepicker refresher scope: ");
          // console.log(scope);
          // console.log("attempting to get at scope through ctrl: ");
          // console.log(DatepickerCtrl.currentCalendarDate);
          DatepickerCtrl.refreshView();

        });
      }
    }
  };
}])

.directive('ooCheckWeekOnScroll', [ '$window', '$document', function($window, $document) {
  return {
    restrict: 'A',
    link: function(scope, element, attrs) {
      var windowHeight, scrollTop, offset, dividingLine, weeks, weekHeight, scrolledWeek, scrolledWeekPage;

      function findCurrentWeek() {
        windowHeight = $(window).height();
        scrollTop = $(window).scrollTop();
        dividingLine = scrollTop + (windowHeight * 0.3);
         
        weeks = angular.element(".week-container");
        scrolledWeek = _.find(weeks, function(week) {
          offset = $(week).offset().top;
          weekHeight = $(week).height();

          return offset <= dividingLine && (offset + weekHeight) > dividingLine;
        });

        return angular.element(scrolledWeek).attr('id');  
      }

      angular.element($document).on('scroll', function() {
        var week = findCurrentWeek();
        if (week !== scope.selected.week ){
          scope.$apply(scope.selectWeek(week));
        }
      });
    }
  };
}])

.directive('ooWeeklyEventTitles', [ function() {
  return {  
    restrict: 'E',
    replace: true,
    templateUrl: 'template/ooWeeklyEventTitles.html',
    // scope: {
    //   selectedWeek: '@',
    //   weeks: '&'
    // },
    link: function(scope, element, attrs) {
      var currentWeek;
      scope.$watch('selected.week', function(newValue, oldValue) {
        if (scope.weeks){
          // _.map( _.findWhere( scope.weeks, {page: newValue} ),
          //   function( week ) {
          //     var title, time, city, venue, venueAbbreviation;
          //   });
          console.log('oldValue: '+oldValue+', newValue: '+newValue);
          console.log('string?', typeof newValue);
          console.log('scope.weeks', scope.weeks);
  
  
          currentWeek = _.findWhere( scope.weeks, {page: newValue} );
          console.log('currentWeek', currentWeek);
          scope.currentWeek = currentWeek;
          console.log(scope);
          // _.map( currentWeek, function(week) {
  
          // });
        }
      });

      scope.$watchCollection('weeks', function(newValue) {
        scope.currentWeek = _.findWhere( scope.weeks, {page: scope.selected.week } );
      });
    }
  };
}]);