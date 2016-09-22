angular.module('uinApp').controller 'MyActivityCtrl', [
  '$scope'
  '$http'
  ($scope, $http) ->
    $http.get('/activities/my_activity.json').success (res) ->
      $scope.upcoming 	= res
      $scope.booking 		= res.upcoming.booking
      $scope.promotion 	= res.upcoming.promotion
      $scope.start_time = moment(res.upcoming.booking.start_time).format('MMMM DD, h:mm a')
      $scope.toScreen		= res.upcoming.toScreen
      $scope.myLastLife = res
    $scope.slides = gon.default_slides
]
