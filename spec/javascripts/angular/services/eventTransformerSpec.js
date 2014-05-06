describe("Event API Transformer", function(){
  var transformer, response;
  beforeEach(module('ooApp'));
  beforeEach(module('ooServices'));
  beforeEach(inject(function(_eventApiTransformer_){
    transformer = _eventApiTransformer_;

    var d1 = new Date(2014,3,4,3);
    var d2 = new Date(2014,3,4,5);
    var d3 = new Date(2014,3,5);
    var d4 = new Date(2014,3,7);
    var d5 = new Date(2014,3,7);

    response = JSON.stringify([
      {title: "one", time: d1},
      {title:"two", time: d2},
      {title:"three", time: d3},
      {title:"four", time: d4},
      {title:"five", time: d5}
    ]);

  }));

  it('returns an empty array when handed one', function(){
    expect(transformer("[]")).toEqual([]);
  });

  it('gives every event a newDay property', function(){
    expect(transformer(response).every(function(element, index, array){
      return element.hasOwnProperty('newDay');
    }));
  });

  it('has newDay true for first event', function(){
    var transformedArr = transformer(response);
    expect(transformedArr[0].newDay).toBe(true);
  });

  it('assigns newDay properly', function(){
    var transformedArr = transformer(response);
    expect(transformedArr[0].newDay).toBe(true);
    expect(transformedArr[1].newDay).toBe(false);
    expect(transformedArr[2].newDay).toBe(true);
    expect(transformedArr[3].newDay).toBe(true);
    expect(transformedArr[4].newDay).toBe(false);
  });
});