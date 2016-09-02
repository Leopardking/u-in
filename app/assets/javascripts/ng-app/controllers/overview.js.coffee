angular.module('uinApp').factory 'reviewService', [
  '$http'
  '$stateParams'
  ($http, $stateParams) ->
    { fetch: (obj) ->
      $http.post('/activities/'+ $stateParams.activityId + '/reviews', review: obj)
    }
]

angular.module('uinApp').controller 'overviewsCtrl', [
  '$scope'
  '$http'
  '$stateParams'
  'reviewService'
  ($scope, $http, $stateParams, reviewService) ->
    $http.get('activities/'+$stateParams.activityId + '.json').success (res) ->
      $scope.promotionhash = res
      return

    $scope.$on '$stateChangeSuccess', ->
      $('.rslides').responsiveSlides()
      jQuery ->
        $("#slider4").responsiveSlides();
        jQuery('#myTab a:last').tab 'show'
        return

    $scope.submit = ->
      obj = 
        content: $scope.reviewForm.content
      localStorage.setItem("search", JSON.stringify(obj))
      reviewService.fetch(obj).success (res, status) ->
        console.log "success"
        return
]


angular.element(document).ready ->
  $('.rslides').responsiveSlides()
  console.log 'slide1'
  return
