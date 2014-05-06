describe('CalendarCtrl', function(){
  var $httpBackend, $controller, $rootscope, $scope, Week, Name,
  createController, dt, staticResponse;

  beforeEach( module('ooApp') );
  beforeEach( module('ooServices') );
  beforeEach( inject(function(
    _$httpBackend_, _$rootScope_, _$controller_, _Week_, _Name_) {
    $httpBackend = _$httpBackend_;
    $controller = _$controller_;
    $rootScope = _$rootScope_;
    $scope = $rootScope.$new();

    Week = _Week_;
    Name = _Name_;
    dt = new Date();

    createController = function(){
      return $controller('CalendarCtrl', { '$scope' : $scope });
    };

    var d1 = new Date(2014,2,4,3);
    var d2 = new Date(2014,2,4,5);
    var d3 = new Date(2014,2,5);
    var d4 = new Date(2014,2,7);
    var d5 = new Date(2014,2,7);

    staticResponse = JSON.stringify([
      {title:"one", time: d1},
      {title:"two", time: d1},
      {title:"three", time: d1},
      {title:"four", time: d2},
      {title:"five", time: d3},
      {title:"six", time: d3},
      {title:"seven", time: d3},
      {title:"eight", time: d4},
      {title:"nine", time: d5},
      {title:"ten", time: d5},
      {title:"eleven", time: d5}
    ]);

    $httpBackend.when('GET').respond(function(method, url, data, headers) {
      var response = [];
      if (url.match(/20140302/)){
        response[0] = 200;
        response[1] = staticResponse;
      }
      else if ( url.match(/page/)){
        var split = url.split("page=");
        query = split[split.length - 1];
        response[0] = 200;
        response[1] = JSON.stringify([{title:"one", time: Name.toDate(query)}]);
      }
      return response;
    });


  }));

  afterEach(function(){
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  });

  it('fetches week on load', function(){
    var request = 'api/events?page='+Name.page(dt);
    $httpBackend.expect('GET', request);
    var CalendarCtrl = createController();
    $httpBackend.flush();
  });

  describe('weeks on scope', function(){
    var CalendarCtrl;
    beforeEach(function(){
      CalendarCtrl = $controller('CalendarCtrl', {$scope: $scope});
      $httpBackend.flush();
    });

    afterEach(function(){
      CalendarCtrl = null;
    });

    it('is an array', function(){
      expect($scope.weeks instanceof Array).toBe(true);
    });

    it('has the right number of days', function(){
      expect($scope.weeks[0].days.length).toBe(1);
    });
  });

  describe('selectDay', function(){
    it('Does something', function(){
      expect(true).toBe(true);
    });
  });

  describe('loading multiple pages', function(){
    describe('isLoaded()', function(){
      var d1, d6, d7, $scope, CalendarCtrl;
      beforeEach(function(){

        // a day described earlier
        d1 = new Date(2014,2,4,3);
        // the next sunday
        d6 = new Date(2014, 2, 9);
        // saturday of current week
        d7 = new Date(2014, 2, 8);
        // $scope = {};

        $scope = $rootScope.$new();
        CalendarCtrl = $controller('CalendarCtrl', {$scope:$scope});

        // get out of range to reset, so only one week is loaded
        $scope.selectDay(new Date(0,0,0,0));
        $scope.selectDay(d1);
        $httpBackend.flush();
      });

      it('returns false when out of range', function(){
        expect($scope.isWeekLoaded(d6)).toBe(false);
      });
      it('returns true when in range', function(){
        expect($scope.isWeekLoaded(d7)).toBe(true);
      });
    });
  });
});


// query({method:'GET', isArray:true, params})