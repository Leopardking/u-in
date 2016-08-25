angular
  .module('uin')
  .controller('PriceController', ['$scope', PriceController] );

function PriceController ($scope) {
   $scope.data = {
    model: null,
    availableOptions: [
      {id: '1', name : "$5- $25"},
      {id: '2', name : "$25- $50"},
      {id: '3', name : "$50- $75"},
      {id: '4', name : "$75- $100"},
      {id: '5', name : "$100- $150"},
      {id: '6', name : "$150- $250"},
      {id: '7', name : "$250 & Up"}
    ]
  };
}
// // angular
// //   .module('uin', [])
// //   .controller('PriceController',['$scope', '$http', function($scope, $http) {
// //     $http.get("http://localhost:3000/activities.json").success(function(res) {
// //       debugger
// //       $scope.datas = res;
// //     });
// // }]);
