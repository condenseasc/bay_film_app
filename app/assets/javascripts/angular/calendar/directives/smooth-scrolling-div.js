
// Smooth scrolls the window to the provided element.
//
angular.module('smoothScroll').factory('smoothScrollingDiv', ['$timeout', function($timeout){
  var smoothScroll = function (element, scrollingDiv, options) {

    var getScrollLocation = function() {
      return scrollingDiv.scrollTop;
    };

    $timeout(function(){
      var startLocation = getScrollLocation(),
        timeLapsed = 0,
        percentage, position;


      // Options
      //
      options = options || {};
      var duration = options.duration || 800,
        offset = options.offset || 0,
        easing = options.easing || 'easeInOutQuart',
        callbackBefore = options.callbackBefore || function() {},
        callbackAfter = options.callbackAfter || function() {};
      

      // Calculate the easing pattern
      //
      var easingPattern = function (type, time) {
        if ( type == 'easeInQuad' ) return time * time; // accelerating from zero velocity
        if ( type == 'easeOutQuad' ) return time * (2 - time); // decelerating to zero velocity
        if ( type == 'easeInOutQuad' ) return time < 0.5 ? 2 * time * time : -1 + (4 - 2 * time) * time; // acceleration until halfway, then deceleration
        if ( type == 'easeInCubic' ) return time * time * time; // accelerating from zero velocity
        if ( type == 'easeOutCubic' ) return (--time) * time * time + 1; // decelerating to zero velocity
        if ( type == 'easeInOutCubic' ) return time < 0.5 ? 4 * time * time * time : (time - 1) * (2 * time - 2) * (2 * time - 2) + 1; // acceleration until halfway, then deceleration
        if ( type == 'easeInQuart' ) return time * time * time * time; // accelerating from zero velocity
        if ( type == 'easeOutQuart' ) return 1 - (--time) * time * time * time; // decelerating to zero velocity
        if ( type == 'easeInOutQuart' ) return time < 0.5 ? 8 * time * time * time * time : 1 - 8 * (--time) * time * time * time; // acceleration until halfway, then deceleration
        if ( type == 'easeInQuint' ) return time * time * time * time * time; // accelerating from zero velocity
        if ( type == 'easeOutQuint' ) return 1 + (--time) * time * time * time * time; // decelerating to zero velocity
        if ( type == 'easeInOutQuint' ) return time < 0.5 ? 16 * time * time * time * time * time : 1 + 16 * (--time) * time * time * time * time; // acceleration until halfway, then deceleration
        return time; // no easing, no acceleration
      };


      // Calculate how far to scroll
      //
      var getEndLocation = function (element) {
        var location = 0;
        // if (element.offsetParent) {
        //   do {
        //     location += element.offsetTop;
        //     element = element.offsetParent;
        //   } while (element);
        // }
        location = element.offsetTop;
        location = Math.max(location - offset, 0);
        return location;
      };
      var endLocation = getEndLocation(element);
      var distance = endLocation - startLocation;


      // Stop the scrolling animation when the anchor is reached (or at the top/bottom of the page)
      //
      var stopAnimation = function () {
        var currentLocation = getScrollLocation();
        if ( position == endLocation || currentLocation == endLocation || ( (window.innerHeight + currentLocation) >= document.body.scrollHeight ) ) {
          clearInterval(runAnimation);
          callbackAfter(element);
        }
      };


      // Scroll the div by an increment, and check if it's time to stop
      //
      var animateScroll = function () {
        timeLapsed += 16;
        percentage = ( timeLapsed / duration );
        percentage = ( percentage > 1 ) ? 1 : percentage;
        position = startLocation + ( distance * easingPattern(easing, percentage) );
        scrollingDiv.scrollTop = position; 
        stopAnimation();
      };


      // Init
      //
      callbackBefore(element);
      var runAnimation = setInterval(animateScroll, 16);
    });
  };

  return smoothScroll;
}]);
