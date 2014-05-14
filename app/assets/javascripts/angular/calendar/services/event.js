'use strict';

ooCalendar.factory('Event', ['$resource', 'eventApiTransformer',
  function($resource, eventApiTransformer) {
    return $resource(
      "api/events/:id", 
      {id: "@id"}
      // ,
      // {query: {
      //   method:'GET',
      //   isArray: true,
      //   transformResponse: eventApiTransformer
      // }}
    ); 
}]);