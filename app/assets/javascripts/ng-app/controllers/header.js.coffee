angular.module('uinApp').controller 'HeaderCtrl', [
	'$scope'
  ($scope) ->
    $scope.toggleCustom = (element) ->
      $('.dropdown-toggle-humberger').click ->
        $('.dropdown-humberger').toglle 800
      return true
]