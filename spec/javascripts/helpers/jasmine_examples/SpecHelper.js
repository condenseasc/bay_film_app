beforeEach(function () {
  jasmine.addMatchers({
    toBePlaying: function () {
      return {
        compare: function (actual, expected) {
          var player = actual;

          return {
            pass: player.currentlyPlayingSong === expected && player.isPlaying
          };
        }
      };
    }
  });
});

// beforeEach(function() {
//   jasmine.addMatchers({
//     toBeUniqueArrayOfPrimitives: function() {
//       return {
//         var test_unique_primitives = function(target){        
//           var value;
//           var arr = target.slice();

//           function recursion(array){
//             if (array.length <=1) {
//               value = true;
//             } else {
//               var comp = array.pop();
              
//               for (var i = array.length - 1; i >= 0; i--) {
//                 if (array[i] == comp){
//                   value = false;
//                   return;
//                 }
//               }
//               recursion(array);
//             }
//           }

//           recursion(arr);
//           return value;
//         };
//         compare: function(actual, expected) {
//         var array = actual;

//           return{
//             pass: test_unique_primitives(array);
//           };
//         }
//       };
//     }
//   });
// });
