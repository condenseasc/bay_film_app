describe('ooRefreshDatepicker', function() {
  var element, $scope;
  beforeEach(module('ooApp'));
  beforeEach(module('ui.bootstrap.datepicker'));
  beforeEach(inject(function(_$rootScope_, _$compile_) {
    $scope = _$rootScope_;
    $compile = _$compile_;

    $scope.selected = {};
    $scope.selected.day = new Date();
    $scope.selected.month = "";

    element = '<datepicker oo-refresh-datepicker refreshOn="{{selected.month}}" date-disabled="isDateDisabled(date, mode)" ng-model="selected.day"></datepicker>';
    $compile(element)($scope);
    $scope.$digest();

    // describe('connects up with page view controller', function() {
    //   it('binds to refreshOn attribute on element', function() {
    //     expect(attrs.refreshOn)
    //   });
    // });

    describe('connects up with datepicker controller', function() {

    });
  }));
});