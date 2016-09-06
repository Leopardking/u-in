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
    $scope.uiConfig = calendar:
      header:
        left: 'prev,next today'
        center: 'title'
        right: 'month agendaWeek agendaDay'
      defaultView: 'agendaDay'
      height: 'auto'

    $http.get('activities/'+$stateParams.activityId + '.json').success (res) ->
      $scope.promotionhash = res
      $scope.reviews = res.reviews

    id = $stateParams.activityId
    start_date = moment().format()
    end_date = moment(start_date).endOf('month').format()
    $scope.eventSource = 
      url: '/calendars/get_events?end_date='+end_date+'&id='+id+'&promotion_id='+id+'&start_date='+start_date
    $scope.eventSources = [$scope.eventSource]

    $scope.submitForm = ->
      reviewService.sending($scope.reviewParam).success (res, status) ->
        $scope.reviews.push(res)
        $("#reviewModal").modal('hide')
        return
]