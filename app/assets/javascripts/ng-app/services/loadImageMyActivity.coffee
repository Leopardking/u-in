angular.module('uinApp', []).factory 'LoadImage', [ ->
	get = (url, id) ->
	  deferred = $q.defer()
	  $http.get(url, params: review_id: id).success((data) ->
	    deferred.resolve data
	    return
	  ).error (error) ->
	    deferred.reject error
	    return
	  deferred.promise
  return
 ]