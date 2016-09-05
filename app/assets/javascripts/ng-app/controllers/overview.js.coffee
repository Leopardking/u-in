angular.module('uinApp').factory 'reviewService', [
  '$http'
  '$stateParams'
  ($http, $stateParams) ->
    { sending: (obj) ->
      $http.post('/activities/'+ $stateParams.activityId + '/reviews', review: obj)
    }
]

angular.module('uinApp').controller 'overviewsCtrl', [
  '$scope'
  '$http'
  '$stateParams'
  'reviewService'
  'sessionService'
  ($scope, $http, $stateParams, reviewService, sessionService) ->
    console.log(sessionService.current_user())
    $http.get('activities/'+$stateParams.activityId + '.json').success (res) ->
      $scope.promotionhash = res
      $scope.reviews = res.reviews
      return

    $scope.submitForm = ->
      reviewService.sending($scope.reviewParam).success (res, status) ->
        $scope.reviews.push(res)
        $("#reviewModal").modal('hide')
        return
]