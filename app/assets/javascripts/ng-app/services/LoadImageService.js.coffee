angular.module('uinApp').factory 'loadImageService', [
  '$q'
  '$http'
  ($q, $http) ->
    obj = {}
    obj.getResponse = (id)->
      temp = {}
      defer = $q.defer()
      $http.get('/activities/load_image', params: review_id: id).success((data) ->
        temp = data
        defer.resolve data
        return
      ).error (result, status, header, config) ->
        defer.reject result
        return
      defer.promise
    obj
]