angular.module('uinApp').factory 'paymentService', [
  '$http'
  '$stateParams'
  ($http, $stateParams) ->
    { chargeSripe: (obj_stripe_token, obj_numbers_booked, obj_promotion_pay_id, obj, object, discount_price, regular_price) ->
      $http.post('/bookings/payment_booking_client', stripe_token: obj_stripe_token, numbers_booked: obj_numbers_booked, promotion_pay_id: $stateParams.activityId, billing_detail: obj, booking: object, discount_price: discount_price, regular_price: regular_price)
    }
]

angular.module('uinApp').factory 'bookingService', [
  '$http'
  '$stateParams'
  ($http, $stateParams) ->
    { booking: (check_status, numbers_booked, object) ->
      $http.post('/bookings/create_new_booking', check_status: status, numbers_booked: numbers_booked, booking: object)
      ignoreLoadingBar: true
    }
]

angular.module('uinApp').controller 'overviewsCtrl', [
  '$scope'
  '$sce'
  '$http'
  '$stateParams'
  'reviewService'
  'paymentService'
  'bookingService'
  'sessionService'
  'uiCalendarConfig'
  '$compile'
  '$window'
  'Notification'
  ($scope, $sce, $http, $stateParams, reviewService, paymentService, bookingService, sessionService, uiCalendarConfig, $compile, $window, Notification) ->
    # key stripe for test
    $window.Stripe.setPublishableKey 'pk_test_GV5ggkXJsOFMFLqyIR3gCScj'
    # default slides on promotion show if unll      
    $scope.slides = gon.default_slides

    $http.get('activities/'+$stateParams.activityId + '.json').success (res) ->
      $scope.promo = res
      $scope.reviews = res.reviews
      $scope.booking_detail = res.booking_detail
      $scope.billing_detail = res.billing_detail
      $scope.city = res.promotion.city
      $scope.adress = res.promotion.street_address_1

      # select box value on booking modal
      $scope.regularPrice = []
      $scope.discountPrice = []
      $scope.totalPrice = ($scope.promo.promotion.price * $scope.regularPrice) + ($scope.promo.promotion.discount_price * $scope.discountPrice)
      $scope.depositDue = $scope.totalPrice * 5 / 100

      $scope.updatePrice = ->
        $scope.totalPrice = ($scope.promo.promotion.price * $scope.regularPrice) + ($scope.promo.promotion.discount_price * $scope.discountPrice)
        $scope.depositDue = $scope.totalPrice * 5 / 100
        
        if $scope.discountPrice[0] != 'undefined'
          $scope.discountPrice == 0
        if $scope.regularPrice[0] != 'undefined'
          $scope.regularPrice == 0
        if ($scope.discountPrice + $scope.regularPrice) > $scope.duration
          $scope.validBooking = "wrong"
        else
          $scope.validBooking = "valid" 

      $scope.regionArray = [{code: "AK", name: "AK"},{code: "AL", name: "AL"},{code: "AR", name: "AR"},{code: "AZ", name: "AZ"},{code: "CA", name: "CA"},{code: "CO", name: "CO"},{code: "CT", name: "CT"},{code: "DE", name: "DE"},{code: "FL", name: "FL"},{code: "GA", name: "GA"},{code: "HI", name: "HI"},{code: "IA", name: "IA"},{code: "ID", name: "ID"},{code: "IL", name: "IL"},{code: "IN", name: "IN"},{code: "KS", name: "KS"},{code: "KY", name: "KY"},{code: "LA", name: "LA"},{code: "MA", name: "MA"},{code: "MD", name: "MD"},{code: "ME", name: "ME"},{code: "MI", name: "MI"},{code: "MN", name: "MN"},{code: "MO", name: "MO"},{code: "MS", name: "MS"},{code: "MT", name: "MT"},{code: "NC", name: "NC"},{code: "ND", name: "ND"},{code: "NE", name: "NE"},{code: "NH", name: "NH"},{code: "NJ", name: "NJ"},{code: "NM", name: "NM"},{code: "NV", name: "NV"},{code: "NY", name: "NY"},{code: "OH", name: "OH"},{code: "OK", name: "OK"},{code: "OR", name: "OR"},{code: "PA", name: "PA"},{code: "RI", name: "RI"},{code: "SC", name: "SC"},{code: "SD", name: "SD"},{code: "TN", name: "TN"},{code: "TX", name: "TX"},{code: "UT", name: "UT"},{code: "VA", name: "VA"},{code: "VT", name: "VT"},{code: "WA", name: "WA"},{code: "WI", name: "WI"},{code: "WV", name: "WV"},{code: "WY", name: "WY"}]

      # Add maps
      # FIX issue SCE docs on https://docs.angularjs.org/api/ng/service/$sce
      # http://stackoverflow.com/questions/21292114/external-resource-not-being-loaded-by-angularjs
      $scope.trustSrc = (src) ->
        $sce.trustAsResourceUrl src

      $scope.maps =
        src: 'https://www.google.com/maps/embed/v1/place?q='+$scope.city+' '+$scope.adress+'&key=AIzaSyAsBv0-tdD2vFyxBONB_wWZGr8A0SSs1Us'
      return

    $scope.showCalendarTwo = ->
      angular.element('.calendar-second').fullCalendar 'today'
      return

    # goTO page modal payment
    $scope.changeToUser =->
      $scope.isHideAmount = true
      return

    $scope.changeToPayment =->
      $scope.isHideUser = true
      check_status = false
      numbers_booked = ($scope.regularPrice + $scope.discountPrice)
      amount              = ($scope.depositDue * 100)
      object =
        book_date: moment().format()
        start_time: moment().format()
        end_time: $scope.end_date
        promotion_id: $stateParams.activityId
        check_discount: true
        promotion_price: 0
        paid_price: amount
        first_name: $scope.firstName
        last_name: $scope.lastName
        email: $scope.email
        phone: $scope.mobile
      return
]
