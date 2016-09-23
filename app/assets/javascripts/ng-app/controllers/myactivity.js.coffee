angular.module('uinApp').controller 'MyActivityCtrl', [
  '$scope'
  '$http'
  ($scope, $http) ->
    $http.get('/activities/my_activity.json').success (res) ->
      $scope.upcoming 	= res.upcoming
      $scope.booking 		= res.upcoming.booking
      $scope.promotion 	= res.upcoming.promotion
      $scope.toScreen		= res.toScreen
      $scope.bookmark		= res.bookmark.booking
      $scope.pastLife		= res.pastLife.booking
    $scope.slides = gon.default_slides

    $scope.showModal = (id, name, image) ->
    	$scope.id = id
    	$scope.name = name
    	$scope.image = image
    	return angular.element('#reviewModal').modal('show')
]
