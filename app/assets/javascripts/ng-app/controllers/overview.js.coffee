angular.module('uinApp').controller 'overviewsCtrl', [
  '$scope'
  '$http'
  '$stateParams'
  ($scope, $http, $stateParams) ->
    $http.get('activities/'+$stateParams.activityId + '.json').success (res) ->
      $scope.promotionhash = res
      debugger
      return
    return
]

angular.module('uinApp').directive 'slider', ->
  linker = ($scope, element, attr) ->
    selector = attr.sliderClassSelector
    watchSelector = attr.sliderRefreshOnWatch
    $scope.$watch watchSelector, ->
      $('.' + selector).responsiveSlides
        auto: true
		    pager: false
		    nav: true
		    speed: 500
		    namespace: "callbacks"
		    before: ->
			    $('.events').append '<li>before event fired.</li>'
			    return
			  after: ->
			    $('.events').append '<li>after event fired.</li>'
			    return  
      return
    return

  {
    restrict: 'A'
    link: linker
  }