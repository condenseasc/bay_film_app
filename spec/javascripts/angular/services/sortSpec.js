describe('Sort', function(){
  var Sort, data, compare;

  beforeEach(module('ooServices'));
  beforeEach(inject(function(_Sort_){
    Sort = _Sort_;

    var d1 = new Date(2014,3,4,3);
    var d2 = new Date(2014,3,4,5);
    var d3 = new Date(2014,3,5);
    var d4 = new Date(2014,3,7);
    var d5 = new Date(2014,3,7);

    data = [
      {title:"one", time: d1},
      {title:"two", time: d1},
      {title:"three", time: d1},
      {title:"four", time: d2},
      {title:"five", time: d3},
      {title:"foo", time: d3},
      {title:"foo", time: d3},
      {title:"foo", time: d4},
      {title:"foo", time: d5},
      {title:"ten", time: d5},
      {title:"eleven", time: d5}];

    test_unique_by_property = function(target, key){        
      var value;
      function recursion(target, key){
        if (target.length <=1) {
          value = true;
        } else {
          var comp = target.pop();
          
          for (var i = target.length - 1; i >= 0; i--) {
            if (target[i][key] == comp[key]){
              value = false;
              return;
            }
          }
          recursion(target, key);
        }
      }

      recursion(target, key);
      return value;
    };

    test_unique = function(target){        
      var value;
      var arr = target.slice();

      function recursion(array){
        if (array.length <=1) {
          value = true;
        } else {
          var comp = array.pop();
          
          for (var i = array.length - 1; i >= 0; i--) {
            if (array[i] == comp){
              value = false;
              return;
            }
          }
          recursion(array);
        }
      }

      recursion(arr);
      return value;
    };

    test_complete = function(sorted, target, key){
      var returnValue;

      for (var i = target.length - 1; i >= 0; i--) {
        var matchValue = false;
        var comp = target[i][key];

        for (var j = sorted.length - 1; j >= 0; j--) {
          if (comp == sorted[j])
            match = true;
        }

        if (match === false) { returnValue = false; return; }
        else { returnValue = true; }
      }

      return returnValue;
    };

    afterEach(function(){
      Sort = data = compare = null;
    });
  }));

  describe('unique()', function(){
    var sorted;
    beforeEach(function(){
      sorted = Sort.unique(data, 'title');
    });

    it('returns unique objects', function(){
      expect(test_unique(sorted)).toBe(true);
      expect(sorted.length).toBe(8);
    });

    it('returns all unique objects from collection', function(){
      expect(test_complete(sorted, data, 'title')).toBe(true);
      expect(sorted).toEqual(["one", "two", "three", "four", "five",
        "foo", "ten", "eleven"]);
    });
  });

  describe('uniqueDates()', function(){
    var sorted;

    beforeEach(function(){
      sorted = Sort.uniqueDates(data);
    });

    it('returns unique objects', function(){
      console.log("sorted unique dates: "+sorted);
      expect(test_unique(sorted)).toBe(true);
      expect(sorted.length).toBe(3);
    });

  });
});