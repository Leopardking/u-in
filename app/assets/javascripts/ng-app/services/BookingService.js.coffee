angular.module('uinApp').factory 'bookingService', ($q, $http, $stateParams) ->
  obj = {}
  obj.createBillingDetail = (obj, object) ->
    temp = {}
    defer = $q.defer()
    $http.get('/activities/build_information_user', params: obj, object).success((data) ->
      temp = data
      defer.resolve data
      return
    ).error (result, status, header, config) ->
      defer.reject result
      return
    defer.promise
  obj

  obj.chargeSripe = (obj_stripe_token, obj_numbers_booked, obj_promotion_pay_id, obj, object, discount_price, regular_price) ->
    temp = {}
    defer = $q.defer()
    $http.post('/bookings/payment_booking_client', stripe_token: obj_stripe_token, numbers_booked: obj_numbers_booked, promotion_pay_id: $stateParams.activityId, billing_detail: obj, booking: object, discount_price: discount_price, regular_price: regular_price).success((data) ->
      temp = data
      defer.resolve data
      return
    ).error (result, status, header, config) ->
      defer.reject result
      return
    defer.promise
  obj