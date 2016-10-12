angular.module('uinApp').controller 'HeaderCtrl', [
	'$scope'
  ($scope) ->
    $scope.show = false
    $scope.toggleCustom = () ->
      if $scope.show == false
        $scope.show =  true
        document.getElementById("nav-hubmerger").style.display = 'block';
      else
        $scope.show =  false
        document.getElementById("nav-hubmerger").style.display = 'none';
]