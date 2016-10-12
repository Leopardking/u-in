angular.module('uinApp').controller 'MyActivityController', [
  '$scope'
  '$http'
  '$window'
  'Notification'
  'Upload'
  '$timeout'
  'loadImageService'
  '$q'
  ($scope, $http, $window, Notification, Upload, $timeout, loadImageService, $q) ->
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
      $scope.review_id = id
      $scope.name = name
      $scope.image = image
      loadImageService.getResponse($scope.review_id).then (rest) ->
        $scope.images_modal = rest
        console.log $scope.images_modal = rest
        return angular.element('#uploadModal').modal('show')
      #return angular.element('#uploadModal').modal('show')
      #$scope.images_modal = loadImageService.get($scope.review_id)
			#loadimageService.get($scope.review_id).success (res, status) ->
			#	$scope.images_modal = res
			#	console.log res
	    #	return angular.element('#uploadModal').modal('show')

    $scope.isHide = false
    $scope.changeToUpload = ->
    	$scope.isHide = true

    $scope.hideToUpload = ->
    	$scope.isHide = false

    $scope.reloadContent = ->
    	$window.location.reload()

    $scope.picFile = ''
    $scope.croppedDataUrl = ''

    $scope.uploadFiles = (dataUrl, name) ->
      Upload.upload(
        url: '/images/upload_image_from_angular?&fromAngular=true'
        data: image: {image: dataUrl, review_id: $scope.review_id}).then ((response) ->
        $timeout ->
          $scope.result = response.data
          return
        return
      ), ((response) ->
        if response.status > 0
          $scope.errorMsg = response.status + ': ' + response.data
        return
      ), (evt) ->
        $scope.progress = parseInt(100.0 * evt.loaded / evt.total)
        return
      return

    return

    $scope.removeBookmark = (id, event, index)->
	    deleteBookmark = $window.confirm('Are you sure you want to remove this activity from your Bucket List')
	    if deleteBookmark
	    	$http.get('/activities/'+ id + '/remove_bookmark').success (res) ->
					$window.location.reload()
	    return

    $scope.removePastLife = (id, event, index)->
    	$http.get('/activities/'+ id + '/remove_past_life').success (res) ->
    		$window.location.reload()

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