angular.module('uinApp').factory 'reviewService', [
  '$http'
  '$stateParams'
  ($http, $stateParams) ->
    { sending: (obj) ->
      $http.post('/activities/'+ $stateParams.activityId + '/reviews', review: obj)
    }
]

angular.module('uinApp').factory 'paymentService', [
  '$http'
  '$stateParams'
  ($http, $stateParams) ->
    { chargeSripe: (obj_stripe_token, obj_numbers_booked, obj_promotion_pay_id, obj) ->
      $http.post('/bookings/payment_booking_client', stripe_token: obj_stripe_token, numbers_booked: obj_numbers_booked, promotion_pay_id: $stateParams.activityId, billing_detail: obj)
    }
]

angular.module('uinApp').factory 'bookingService', [
  '$http'
  '$stateParams'
  ($http, $stateParams) ->
    { booking: (check_status, numbers_booked, object) ->
      $http.post('/bookings/create_new_booking', check_status: status, numbers_booked: numbers_booked, booking: object)
    }
]

angular.module('uinApp').controller 'overviewsCtrl', [
  '$scope'
  '$http'
  '$stateParams'
  'reviewService'
  'paymentService'
  'bookingService'
  'sessionService'
  'uiCalendarConfig'
  '$compile'
  '$window'
  ($scope, $http, $stateParams, reviewService, paymentService, bookingService, sessionService, uiCalendarConfig, $compile, $window) ->
    $window.Stripe.setPublishableKey 'pk_test_GV5ggkXJsOFMFLqyIR3gCScj'
    $http.get('activities/'+$stateParams.activityId + '.json').success (res) ->
      $scope.promotionhash = res
      $scope.reviews = res.reviews
      $scope.booking_detail = res.booking_detail

      # select box value on booking modal
      $scope.perDuration = $scope.booking_detail.bookings_per_duration_arr
      $scope.maximumBoking = $scope.booking_detail.maximum_bookings_arr
      $scope.regularPrice = []
      $scope.discountPrice = []
      $scope.totalPrice = ($scope.promotionhash.promotion.price * $scope.regularPrice) + ($scope.promotionhash.promotion.price * $scope.discountPrice)
      $scope.depositDue = $scope.totalPrice * 5 / 100

      $scope.updatePrice = ->
        $scope.totalPrice = ($scope.promotionhash.promotion.price * $scope.regularPrice) + ($scope.promotionhash.promotion.price * $scope.discountPrice)
        $scope.depositDue = $scope.totalPrice * 5 / 100

    $scope.modalOnEventClick = (event, date, jsEvent, view) ->
      $scope.end_date =  event.end._i
      date_completed = moment(event.start).format('h:mm a on dddd, D MMMM YYYY')
      $scope.date_completed = date_completed
      $('#modalTitle').html event.title
      $('#modalBody').html event.description
      $('#fullCalModal').modal()
      $('[data-toggle="tooltip"]').tooltip()

    $scope.eventRender = (event, element, view) ->
      element.css
        'border-color': '#3C3B3B'
        'border-width': '1px'
        'border-style': 'solid'
        'margin-bottom': '2px'
        'min-height': '70px'
        'background-color': ''
      element.find('.fc-content').css
        'background-color': '#0099FF'
        'color': '#FFFFFF'
      element.find('.fc-bg').css
        'background-color': '#0099FF'
        'color': '#FFFFFF'
      booking_tag = "<div class='booking-event'><div class='booking-space'><p>SPACE DUMMY</p></div><div class='booking-price'>$5000</div><div class='booking-button'><p>I'm In! <br> Book it!</p></div></div>"
      element.append(booking_tag)
      return

    # popup datepicker 
    disabled = (data) ->
      date = data.date
      mode = data.mode
      mode == 'day' and (date.getDay() == 0 or date.getDay() == 6)

    getDayClass = (data) ->
      date = data.date
      mode = data.mode
      if mode == 'day'
        dayToCheck = new Date(date).setHours(0, 0, 0, 0)
        i = 0
        while i < $scope.events.length
          currentDay = new Date($scope.events[i].date).setHours(0, 0, 0, 0)
          if dayToCheck == currentDay
            return $scope.events[i].status
          i++
      ''

    $scope.today = ->
      $scope.dt = new Date
      return

    $scope.today()

    $scope.clear = ->
      $scope.dt = null
      return


    $scope.dateOptions =
      customClass: getDayClass
      showWeeks: true
      formatYear: 'yy'
      maxDate: new Date((String(new Date().getFullYear() + 10)))
      minDate: new Date
      startingDay: 0

    $scope.openDate = ->
      $scope.popup1.opened = true
      return

    $scope.setDate = (year, month, day) ->
      $scope.dt = new Date(year, month, day)
      return

    $scope.altInputFormats = [ 'M!/d!/yyyy' ]
    $scope.popup1 = opened: false
    tomorrow = new Date
    tomorrow.setDate tomorrow.getDate() + 1
    afterTomorrow = new Date
    afterTomorrow.setDate tomorrow.getDate() + 1

    $scope.events = [
      {
        date: tomorrow
        status: 'full'
      }
      {
        date: afterTomorrow
        status: 'partially'
      }
    ]

    $scope.getNumber = (num) ->
      new Array(num)

    # ui config ui calendar angular
    $scope.uiConfig = calendar:
      header:
        left: ''
        center: 'prev title next'
        right: 'agendaWeek'
      defaultView: 'agendaWeek'
      height: 'auto'
      eventClick: $scope.modalOnEventClick
      eventRender: $scope.eventRender
      eventColor: '#378006'
    
    # get date from datepicker
    $scope.$watch 'dt', ->
      angular.element('.calendar-overview').fullCalendar('gotoDate', $scope.dt)
      return

    # parsing ui-calender json
    id = $stateParams.activityId
    start_date = $scope.dt
    end_date = moment(start_date).endOf('month').format()
    $scope.eventSource = 
      url: '/calendars/get_events?end_date='+end_date+'&id='+id+'&promotion_id='+id+'&start_date='+start_date
    $scope.eventSources = [$scope.eventSource]

    # submit reveiw
    $scope.submitForm = ->
      reviewService.sending($scope.reviewParam).success (res, status) ->
        $scope.reviews.push(res)
        $("#reviewModal").modal('hide')
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
      bookingService.booking(check_status, numbers_booked, object).success (res, status) ->
      return

    # for stripe integration
    $scope.stripeCallback = (code, result) ->     
      if result.error
        console.log 'it failed! error: ' + result.error.message
      else
        # obj_stripe_token, obj_numbers_booked, obj_promotion_pay_id, obj
        current_user_id     = gon.current_user.current_user_id
        obj_stripe_token    = result.id
        obj_numbers_booked  = ""
        amount              = ($scope.depositDue * 100)
        obj =  
          same_as_company_address: 0
          first_name: $scope.firstName
          last_name: $scope.lastName
          street_address: $scope.street
          street_address_2: $scope.street2
          city: $scope.city
          state: $scope.state
          zipcode: $scope.zipCode
          phone: $scope.mobile
          email: $scope.email
          card_type: "visacard"
          name_card: ($scope.firstName + $scope.lastName)
          ccard_last4: $scope.number
          exp_month: $scope.expiry
          exp_year: $scope.expiry
          security_code: $scope.csv
          amount: $scope.depositDue
        paymentService.chargeSripe(result.id, "", "", obj).success (res, status) ->
          $("#fullCalModal").modal('hide')
      return
]