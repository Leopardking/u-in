angular.module('uinApp').controller 'MyActivityCtrl', [
  '$scope'
  '$http'
  '$window'
  'Notification'
  ($scope, $http, $window, Notification) ->
    $http.get('/activities/my_activity.json').success (res) ->
      $scope.upcoming 	= res.upcoming
      $scope.booking 		= res.upcoming.booking
      $scope.promotion 	= res.upcoming.promotion
      $scope.toScreen		= res.toScreen
      $scope.bookmark		= res.bookmark.booking
      $scope.pastLife		= res.pastLife.booking
    $scope.slides = gon.default_slides
    $scope.default_image_upload = gon.default_image_upload 
    $scope.camera = gon.camera

    $scope.showModal = (id, name, image) ->
    	$scope.id = id
    	$scope.name = name
    	$scope.image = image
    	return angular.element('#reviewModal').modal('show')

    $scope.uploadModal = (id, name, image) ->
    	$scope.id = id
    	$scope.name = name
    	$scope.image = image
    	return angular.element('#uploadModal').modal('show')

    $scope.isHide = false
    $scope.changeToUpload = ->
    	$scope.isHide = true

    $scope.hideToUpload = ->
    	$scope.isHide = false

    $scope.removeBookmark = (id, event, index)->
	    deleteUser = $window.confirm('Are you sure you want to remove this activity from your Bucket List')
	    if deleteUser
	    	$http.get('/activities/'+ id + '/remove_bookmark').success (res) ->
					$window.location.reload()
	    return

    $scope.reviewParam = {}
    $scope.submitForm = ->
      id = $scope.id
      obj =
        content: $scope.reviewParam.content
        rating: $scope.reviewParam.rating
        user_id: gon.current_user.current_user_id
      $http.post('/activities/'+ id + '/reviews', review: obj).success (res) ->
        $window.location.reload()
      	Notification.success('Thanks for rate this activity')
 				return

]
