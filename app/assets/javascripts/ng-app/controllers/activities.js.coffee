angular.module('uinApp').controller 'ActivitiesCtrl', [
  '$scope'
  '$http'
  ($scope, $http) ->
    if localStorage.getItem('search') == null
      localStorage.setItem("search", JSON.stringify({}))
    $scope.itemArray = [
      {
        range: "5..25"
        name: '$5-$25'
      }
      {
        range: "25..50"
        name: '$25-$50'
      }
      {
        range: "50..75"
        name: '$50-$75'
      }
      {
        range: "75..100"
        name: '$75-$100'
      }
      {
        range: "100..150"
        name: '$100-$150'
      }
      {
        range: "150..250"
        name: '$150-$250'
      }
      {
        range: "250"
        name: '$250 & up'
      }
    ]
    $http.get('/activities.json').success (res) ->
      $scope.activities = res
      return
    
    $scope.price = (price) ->
      obj = JSON.parse(localStorage.getItem("search"))
      if price == undefined
        delete obj["price_range"];
      else
        price_range = price.range
        obj.price_range = price_range
      localStorage.setItem("search", JSON.stringify(obj))
      $http.get('/activities.json', params:
        criteria: obj)
      .success (res, status) ->
        $scope.activities = res
        return

    $scope.city = (event, city) ->
      if event.keyCode == 13
        obj = JSON.parse(localStorage.getItem("search"))
        obj.city = city
        localStorage.setItem("search", JSON.stringify(obj))
        $http.get('/activities.json', params:
          criteria: obj)
        .success (res, status) ->
          $scope.activities = res
          return

    $scope.zipcode = (event, zipcode) ->
      if event.keyCode == 13
        obj = JSON.parse(localStorage.getItem("search"))
        obj.zipcode = zipcode
        localStorage.setItem("search", JSON.stringify(obj))
        $http.get('/activities.json', params:
          criteria: obj)
        .success (res, status) ->
          $scope.activities = res
          return

    $scope.$on '$destroy', ->
      localStorage.removeItem("search")
      return
]