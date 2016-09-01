angular.module('uinApp').controller 'overviewsCtrl', [
  '$scope'
  '$http'
  '$stateParams'
  ($scope, $http, $stateParams) ->
    $http.get('activities/'+$stateParams.activityId + '.json').success (res) ->
      $scope.promotionhash = res
      return
    return

    $scope.$on '$stateChangeSuccess', ->
      $('.rslides').responsiveSlides()
      console.log 'slide'
      jQuery ->
        $("#slider4").responsiveSlides();
        jQuery('#myTab a:last').tab 'show'
        return
]


angular.element(document).ready ->
  $('.rslides').responsiveSlides()
  console.log 'slide1'
  return
