angular.module('uinApp').factory 'activitiesService', ($q, $http) ->
  obj = {}
  obj.fetch = (obj, page, statePopular) ->
    temp = {}
    defer = $q.defer()
    $http.get('/activities.json', params: criteria: obj, page: page, popular: statePopular).success((data) ->
      temp = data
      defer.resolve data
      return
    ).error (result, status, header, config) ->
      defer.reject result
      return
    defer.promise
  obj

  obj.genre = ->
    temp = {}
    defer = $q.defer()
    $http.get('/activities/genre.json').success((data) ->
      temp = data
      defer.resolve data
      return
    ).error (result, status, header, config) ->
      defer.reject result
      return
    defer.promise
  obj

  obj.bookmark = (promotion_id)->
    temp = {}
    defer = $q.defer()
    $http.post('/activities/'+promotion_id+'/bookmark').success((data) ->
      temp = data
      defer.resolve data
      return
    ).error (result, status, header, config) ->
      defer.reject result
      return
    defer.promise
  obj