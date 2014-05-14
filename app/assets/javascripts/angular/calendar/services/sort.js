'use strict';

// ended up with a different function
// read the other one and figure it out!
ooCalendar.factory('Sort', [ function(){
  var Sort = {
    uniqueDates: function(data){
      // console.log("input to uniqueDates(): "+JSON.stringify(data));
      if (typeof data === 'undefined') {return [];}
      var array = data.map(function(element, index, array){
        return {time: new Date(element.time).toDateString()};
      });

      // for (var i = array.length - 1; i >= 0; i--) {
      //   array[i].time = new Date(array[i].time).toDateString();
      // }
      // console.log("input to unique() from uniqueDates(): "+array);
      // console.log("data at input to unique() from uniqueDates(): "+JSON.stringify(data));


      var result = this.unique(array, 'time');
      // console.log("returned from unique(): "+result);
      result.forEach(function(element, index, array){
        array[index] = new Date(element);
      });
      // console.log("result of uniqueDates"+result);

      return result;
    },
    unique: function(data, key){
      var result = [];
      for (var i = 0, length = data.length; i < length; i++) {
        var value = data[i][key];
        if (result.indexOf(value) == -1)
          result.push(value);
      }
      return result;
    }
  };
  return Sort;
}]);
