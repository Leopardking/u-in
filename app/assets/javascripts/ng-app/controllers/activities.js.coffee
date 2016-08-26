angular.module('uinApp').factory 'activitiesService', ($http) ->
  { fetch: (obj, page, statePopular) ->
    $http.get('/activities.json', params:
      criteria: obj, page: page, popular: statePopular)
 }

angular.module('uinApp').controller 'ActivitiesCtrl', [
  '$scope'
  '$http'
  'activitiesService'
  ($scope, $http, activitiesService) ->
    if localStorage.getItem('search') == null
      localStorage.setItem("search", JSON.stringify({}))
    $scope.itemArray = [{range: "5..25", name: '$5-$25'}, {range: "25..50", name: '$25-$50'}, {range: "50..75", name: '$50-$75'}, {range: "75..100", name: '$75-$100'}, {range: "100..150", name: '$100-$150'}, {range: "150..250", name: '$150-$250'}, {range: "250", name: '$250 & up'}
    ]
    $scope.statePopular = false
    $scope.regionArray = [{code: "AK", name: "AK"},{code: "AL", name: "AL"},{code: "AR", name: "AR"},{code: "AZ", name: "AZ"},{code: "CA", name: "CA"},{code: "CO", name: "CO"},{code: "CT", name: "CT"},{code: "DE", name: "DE"},{code: "FL", name: "FL"},{code: "GA", name: "GA"},{code: "HI", name: "HI"},{code: "IA", name: "IA"},{code: "ID", name: "ID"},{code: "IL", name: "IL"},{code: "IN", name: "IN"},{code: "KS", name: "KS"},{code: "KY", name: "KY"},{code: "LA", name: "LA"},{code: "MA", name: "MA"},{code: "MD", name: "MD"},{code: "ME", name: "ME"},{code: "MI", name: "MI"},{code: "MN", name: "MN"},{code: "MO", name: "MO"},{code: "MS", name: "MS"},{code: "MT", name: "MT"},{code: "NC", name: "NC"},{code: "ND", name: "ND"},{code: "NE", name: "NE"},{code: "NH", name: "NH"},{code: "NJ", name: "NJ"},{code: "NM", name: "NM"},{code: "NV", name: "NV"},{code: "NY", name: "NY"},{code: "OH", name: "OH"},{code: "OK", name: "OK"},{code: "OR", name: "OR"},{code: "PA", name: "PA"},{code: "RI", name: "RI"},{code: "SC", name: "SC"},{code: "SD", name: "SD"},{code: "TN", name: "TN"},{code: "TX", name: "TX"},{code: "UT", name: "UT"},{code: "VA", name: "VA"},{code: "VT", name: "VT"},{code: "WA", name: "WA"},{code: "WI", name: "WI"},{code: "WV", name: "WV"},{code: "WY", name: "WY"}]
    activitiesService.fetch({}, 1, $scope.statePopular).success (res, status) ->
      $scope.activities = res.activities
      $scope.next_page = res.next_page

    $http.get('/activities/genre.json').success (res) ->
      $scope.genres = res
      return

    $scope.mostPopular = (statePopular) ->
      obj = JSON.parse(localStorage.getItem("search"))
      if statePopular
        $scope.statePopular = false
      else
        $scope.statePopular = true
      activitiesService.fetch(obj, 1, $scope.statePopular).success (res, status) ->
        $scope.activities = res.activities
        $scope.next_page = res.next_page
        return

    $scope.nextPage = (next_page) ->
      if next_page != null
        obj = JSON.parse(localStorage.getItem("search"))
        activitiesService.fetch(obj, next_page, $scope.statePopular).success (res, status) ->
          $scope.activities = $scope.activities.concat(res.activities)
          $scope.next_page = res.next_page
          return

    $scope.price = (price) ->
      obj = JSON.parse(localStorage.getItem("search"))
      if price == undefined
        delete obj["price_range"];
      else
        price_range = price.range
        obj.price_range = price_range
      localStorage.setItem("search", JSON.stringify(obj))
      activitiesService.fetch(obj, 1, $scope.statePopular).success (res, status) ->
        $scope.activities = res.activities
        $scope.next_page = res.next_page
        return

    $scope.city = (event, city) ->
      if event.keyCode == 13
        obj = JSON.parse(localStorage.getItem("search"))
        obj.city = city
        localStorage.setItem("search", JSON.stringify(obj))
        activitiesService.fetch(obj, 1, $scope.statePopular).success (res, status) ->
          $scope.activities = res.activities
          $scope.next_page = res.next_page
          return

    $scope.region = (region) ->
      obj = JSON.parse(localStorage.getItem("search"))
      if region == undefined
        delete obj["state"];
      else
        obj.state = region.code
      localStorage.setItem("search", JSON.stringify(obj))
      activitiesService.fetch(obj, 1, $scope.statePopular).success (res, status) ->
        $scope.activities = res.activities
        $scope.next_page = res.next_page
        return

    $scope.zipcode = (event, zipcode) ->
      if event.keyCode == 13
        obj = JSON.parse(localStorage.getItem("search"))
        obj.zipcode = zipcode
        localStorage.setItem("search", JSON.stringify(obj))
        activitiesService.fetch(obj, 1, $scope.statePopular).success (res, status) ->
          $scope.activities = res.activities
          $scope.next_page = res.next_page
          return

    $scope.list = []
    $scope.text = ''
    $scope.submit = ->
      if $scope.text
        $scope.list.push @text
        $scope.text = ''
      return

    $scope.$on '$destroy', ->
      localStorage.removeItem("search")
      return
]