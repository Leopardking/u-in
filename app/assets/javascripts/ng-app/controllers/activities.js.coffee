window.uinApp.controller 'ActivitiesCtrl', [
  '$scope'
  '$http'
  ($scope, $http) ->
    if localStorage.getItem('search') == null
      localStorage.setItem("search", JSON.stringify({}))
    $http.get('/activities.json').success (res) ->
      $scope.activities = res
      return

    $scope.drawWinner = (price) ->
      obj = JSON.parse(localStorage.getItem("search"))
      $http.get('/activities.json', params:
        price_range: localStorage.search.price_range)
      .success (res, status) ->
        $scope.activities = res
        return

    $scope.city = (event, city) ->
      if event.keyCode == 13
        obj = JSON.parse(localStorage.getItem("search"))
        obj.city = city
        localStorage.setItem("search", JSON.stringify(obj))
        $http.get('/activities.json', params:
          city: obj.city)
        .success (res, status) ->
          $scope.activities = res
          return

    $scope.zipcode = (event, zipcode) ->
      if event.keyCode == 13
        obj = JSON.parse(localStorage.getItem("search"))
        obj.zipcode = zipcode
        localStorage.setItem("search", JSON.stringify(obj))
        $http.get('/activities.json', params:
          zipcode: obj.zipcode)
        .success (res, status) ->
          $scope.activities = res
          return

    $scope.$on '$destroy', ->
      localStorage.removeItem("search")
      return
]