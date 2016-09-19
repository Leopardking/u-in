angular.module('uinApp').controller 'HeaderCtrl', [
	'$scope'
  ($scope) ->
    $scope.toggleCustom = (element) ->
      $('.dropdown-humberger').toggle()
    return true
]