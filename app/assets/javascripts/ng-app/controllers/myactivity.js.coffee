angular.module('uinApp').controller 'MyActivityCtrl', [
  '$scope'
  '$http'
  ($scope, $http) ->
    $scope.slides = gon.default_slides
]
