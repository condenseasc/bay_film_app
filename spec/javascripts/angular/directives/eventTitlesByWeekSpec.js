'use strict';
/*global it, describe, angular, inject, beforeEach, afterEach, module, console, expect*/

describe('ooSidebarEventTitlesByWeek', function () {
  var $compile, $controller, $rootScope, $scope, $httpBackend, createController, weekOne, weekTwo;

  beforeEach(module('ooApp'));
  beforeEach(module('ooCalendar'));
  beforeEach(inject(function (_$compile_, _$controller_, _$rootScope_, _$httpBackend_) {
    $compile = _$compile_;
    $controller = _$controller_;
    $rootScope = _$rootScope_;
    $scope = $rootScope.$new();
    $httpBackend = _$httpBackend_;



    createController = function () {
      return $controller('CalendarCtrl', { '$scope': $scope });
    };

    weekOne = [{"id":105,"time":"2014-08-17T19:00:00.000-05:00","title":"Arsenal","description":"","venue_id":1,"series_id":10,"venue":{"id":1,"name":"Pacific Film Archive","abbreviation":"PFA","city":null},"series":{"id":10,"title":"Over the Top and into the Wire: WWI on Film","description":""}}];
    weekTwo = [{"id":69,"time":"2014-08-17T21:00:00.000-05:00","title":"Sansho the Bailiff","description":"","venue_id":1,"series_id":5,"venue":{"id":1,"name":"Pacific Film Archive","abbreviation":"PFA","city":null},"series":{"id":5,"title":"Kenji Mizoguchi: A Cinema of Totality","description":""}}];

    // var week_1 = JSON.parse(["days":["date":""]])

      // '[{
      //   "id": 105,
      //   "time": "2014-08-17T19:00:00.000-05:00",
      //   "title": "Arsenal",
      //   "description": "",
      //   "venue_id": 1,
      //   "series_id": 10,
      //   "venue": {
      //     "id": 1,
      //     "name": "Pacific Film Archive Theater",
      //     "abbreviation": "PFA",
      //     "city": null
      //   },
      //   "series": {
      //     "id": 10,
      //     "title": "Over the Top and into the Wire: WWI on Film",
      //     "description": ""
      //   }
      // }]'

      // '[{
      //   "id": 69,
      //   "time": "2014-08-17T21:00:00.000-05:00",
      //   "title": "Sansho the Bailiff",
      //   "",
      //   "venue_id": 1,
      //   "series_id": 5,
      //   "venue": {
      //     "id": 1,
      //     "name": "Pacific Film Archive",
      //     "city": null
      //   },
      //   "series": {
      //     "id": 5,
      //     "title": "Kenji Mizoguchi: A Cinema of Totality",
      //     "description": ""
      //   }
      // }]'

    // weekOne = JSON.stringify([{
    //   page: "20140511",
    //   days: [{
    //     date: "2014-05-14T19:00:00.000-05:00",
    //     events: {
    //       title: "Title One"
    //     }
    //   }]
    // }]);

    // weekTwo = JSON.stringify([{
    //   page: "20140518",
    //   days: [{
    //     date: "2014-05-19T17:30:00.000-05:00",
    //     events: {
    //       title: "Title Two"
    //     }
    //   }]
    // }]);

    $httpBackend.when('GET').respond(function(method, url, data, headers) {
      var response = [];
      if (url.match(/20140817/)){
        response[0] = 200;
        response[1] = weekOne;
        console.log("response gets made");
      }
      else if ( url.match(/20140824/)){
        response[0] = 200;
        response[1] = weekTwo;
      }
      else {
        response[0] = 200;
        return response;
      }
      console.log("response: ", response);
      return response;
    });


  }));

  afterEach(function(){
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  });

  describe('connects up with page controller', function () {
    var CalendarCtrl, element;

    beforeEach(function () {
      CalendarCtrl = createController();
      $httpBackend.flush();
      $scope.weeks = 
      element = angular.element('<oo-event-titles-by-week loaded-weeks="weeks" selected-week-name="{{selected.week}}" nav-to="scrollTo(id)"></oo-event-titles-by-week>');
      $compile(element)($scope);

      $scope.$digest();
      $httpBackend.flush();
    });

    it("changes titles based on selected.week", function () {
      // $scope.selectDay(new Date(2014, 7, 19));
      // $scope.$digest();
      // $httpBackend.flush();

      // console.log(element.html());
      // console.log(element.scope());

      // expect(element.css(".list-event-title").html()).toEqual("Arsenal");
    });
  });

  it('repeats over a template', function () {

  });

  it('provides links to events on the page', function () {

  });
});