angular.module('uinApp').controller 'ActivitiesCtrl', [
  '$scope'
  '$http'
  ($scope, $http) ->
    $http.get('/activities.json').success (res) ->
      $scope.activities = res
      return
    return
]