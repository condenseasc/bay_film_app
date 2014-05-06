describe('ooWeeklyEventTitles', function() {
  var CalendarCtrl, $controller, $rootScope, $scope, createController;

  beforeEach( module( 'ooApp' ) );
  beforeEach( module( 'ooDirectives' ) );
  beforeEach( $inject( function( _$controller_, _$rootScope_ ) {
    $controller = _$controller_;
    $rootScope = _$rootScope_;
    $scope = $rootScope.$new();

    createController = function() {
      return $controller('CalendarCtrl', { 'scope': $scope } );
    };
  }));

  it('responds to changes in selected.week on page controller', function(){

  });

  it('repeats over a template', function(){

  });

  it('provides links to events on the page', function(){

  });
});