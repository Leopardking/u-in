angular.module('uinApp').factory 'reviewService', [
  '$http'
  '$stateParams'
  ($http, $stateParams) ->
    { sending: (obj) ->
      $http.post('/activities/'+ $stateParams.activityId + '/reviews', review: obj)
    }
]

angular.module('uinApp').controller 'reviewController', ($scope) ->
  return

angular.module('uinApp').controller 'reviewController', [
  '$scope'
  '$http'
  '$stateParams'
  'reviewService'
  'Notification'
  ($scope, $http, $stateParams, reviewService, Notification) ->
	# submit reveiw

    $scope.reviewParam = {}
    $scope.submitForm = ->
      obj = 
        content: $scope.reviewParam.content
        rating: $scope.reviewParam.rating
        user_id: gon.current_user.current_user_id
      reviewService.sending(obj).success((res, status) ->
        $scope.reviews.push(res)
        $("#reviewModal").modal('hide')
        Notification.success('Your rate has been created')
        return
      ).error (res, status) ->
        Notification.warning('Something went wrong')
]