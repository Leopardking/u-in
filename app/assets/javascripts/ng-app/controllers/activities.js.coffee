angular.module('uinApp').controller 'ActivitiesCtrl', [
  '$scope'
  '$http'
  ($scope, $http) ->
    if localStorage.getItem('search') == null
      localStorage.setItem("search", JSON.stringify({}))
    $scope.itemArray = [{range: "5..25", name: '$5-$25'}, {range: "25..50", name: '$25-$50'}, {range: "50..75", name: '$50-$75'}, {range: "75..100", name: '$75-$100'}, {range: "100..150", name: '$100-$150'}, {range: "150..250", name: '$150-$250'}, {range: "250", name: '$250 & up'}
    ]

    $scope.regionArray = [{code: "AK", name: "AK"},{code: "AL", name: "AL"},{code: "AR", name: "AR"},{code: "AZ", name: "AZ"},{code: "CA", name: "CA"},{code: "CO", name: "CO"},{code: "CT", name: "CT"},{code: "DE", name: "DE"},{code: "FL", name: "FL"},{code: "GA", name: "GA"},{code: "HI", name: "HI"},{code: "IA", name: "IA"},{code: "ID", name: "ID"},{code: "IL", name: "IL"},{code: "IN", name: "IN"},{code: "KS", name: "KS"},{code: "KY", name: "KY"},{code: "LA", name: "LA"},{code: "MA", name: "MA"},{code: "MD", name: "MD"},{code: "ME", name: "ME"},{code: "MI", name: "MI"},{code: "MN", name: "MN"},{code: "MO", name: "MO"},{code: "MS", name: "MS"},{code: "MT", name: "MT"},{code: "NC", name: "NC"},{code: "ND", name: "ND"},{code: "NE", name: "NE"},{code: "NH", name: "NH"},{code: "NJ", name: "NJ"},{code: "NM", name: "NM"},{code: "NV", name: "NV"},{code: "NY", name: "NY"},{code: "OH", name: "OH"},{code: "OK", name: "OK"},{code: "OR", name: "OR"},{code: "PA", name: "PA"},{code: "RI", name: "RI"},{code: "SC", name: "SC"},{code: "SD", name: "SD"},{code: "TN", name: "TN"},{code: "TX", name: "TX"},{code: "UT", name: "UT"},{code: "VA", name: "VA"},{code: "VT", name: "VT"},{code: "WA", name: "WA"},{code: "WI", name: "WI"},{code: "WV", name: "WV"},{code: "WY", name: "WY"}]
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
          
    $scope.region = (region) ->
      obj = JSON.parse(localStorage.getItem("search"))
      if region == undefined
        delete obj["state"];
      else
        obj.state = region.code
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