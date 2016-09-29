angular.module('uinApp').factory 'paymentService', [
  '$http'
  '$stateParams'
  ($http, $stateParams) ->
    { chargeSripe: (obj_stripe_token, obj_numbers_booked, obj_promotion_pay_id, obj, object, discount_price, regular_price) ->
      $http.post('/bookings/payment_booking_client', stripe_token: obj_stripe_token, numbers_booked: obj_numbers_booked, promotion_pay_id: $stateParams.activityId, billing_detail: obj, booking: object, discount_price: discount_price, regular_price: regular_price)
    }
]

angular.module('uinApp').controller 'calendarController', [
  '$scope'
  '$sce'
  '$http'
  '$stateParams'
  'reviewService'
  'paymentService'
  'sessionService'
  'uiCalendarConfig'
  '$compile'
  '$window'
  'Notification'
  ($scope, $sce, $http, $stateParams, reviewService, paymentService, sessionService, uiCalendarConfig, $compile, $window, Notification) ->
    # key stripe for test
    $window.Stripe.setPublishableKey 'pk_test_GV5ggkXJsOFMFLqyIR3gCScj'
    $scope.modalOnEventClick = (event, date, jsEvent, view) ->
      check_day = moment(event.start._i).format("YYYY-MM-DD h:mm:ss")
      today     = moment().format("YYYY-MM-DD h:mm:ss")
      
      if $scope.billing_detail != undefined
        $scope.firstName = $scope.billing_detail.first_name
        $scope.lastName = $scope.billing_detail.last_name
        $scope.street = $scope.billing_detail.street_address
        $scope.street2 = $scope.billing_detail.street_address_2
        $scope.city = $scope.billing_detail.city
        $scope.state = $scope.billing_detail.state
        $scope.zipCode = $scope.billing_detail.zipcode
        $scope.mobile = $scope.billing_detail.phone
        $scope.email = $scope.billing_detail.email
        $scope.cardType = $scope.billing_detail.card_type
        $scope.number = $scope.billing_detail.number
        $scope.expiry           = $scope.billing_detail.exp_month.toString() + "/" + $scope.billing_detail.exp_year.toString()
        $scope.cvc = $scope.billing_detail.security_code

      $scope.duration  = $scope.booking_detail.bookings_per_duration
      perDuration = $scope.duration - event.number_bookings_in_current_period
      maximumBoking = event.booking_promotion_avaiable
      # for select box on show popup
      $scope.perDuration = Array.apply(null, length: perDuration).map((value, index) ->
        index + 1
      )
      $scope.perDuration.splice(0, 0, 0);
      $scope.maximumBoking = Array.apply(null, length: maximumBoking).map((value, index) ->
        index + 1
      )
      $scope.maximumBoking.splice(0, 0, 0);
      
      if check_day < today
        if event.blackout == true
          alert 'You can\'t cancel this blackout'
        else
          alert 'You can\'t choice Previous Day'
      else if check_day = today
        if event.blackout == true
          alert 'You can\'t cancel this blackout'
        else if event.event_status == "sold_out"
          alert 'This promotion is sold out, please try any other time'
        else
          $scope.end_date = moment(event.end).format('YYYY-MM-DD h:mm:ss Z')
          date_completed = moment(event.start).format('h:mm a on dddd, D MMMM YYYY')
          $scope.start_date = moment(event.start).format('YYYY-MM-DD h:mm:ss Z')
          $scope.book_date  = moment(event.start).format('YYYY-MM-DD')
          $scope.date_completed = date_completed

          $('#modalTitle').html event.title
          $('#modalBody').html event.description
          $('#fullCalModal').modal()
          $('[data-toggle="tooltip"]').tooltip()
      else
        if event.blackout == true
          alert 'You can\'t cancel this blackout'
        else
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

      switch event.event_status
        when 'regular_available'         
          $(element).find('.fc-title')[0].innerHTML = "REGULAR PRICE"
          element.find('.fc-content').css
            'background-color': '#3A4A5B'
            'color': '#FFFFFF'
            'border-top-style': 'solid'
            'border-color': '#99CC00'
          booking_tag = "
            <div class='booking-wraper'>
              <div class='booking-header'>
              </div>
              <div class='booking-space'>
                <p>5 SPACES</p>
                <p> $ "+$scope.promo.promotion.price+"</p>
              </div>
            <div class='booking-button-regular'>
              <p>I'm In! <br> Book it!</p>
            </div>
          </div>"
          $(element).find('.booking-button-regular').css
            'background-color': '#3A4A5B !important'
        when 'sold_out'
          element.find('.fc-content').css
            'background-color': '#31708f'
            'color': '#FFFFFF'
            'border-top-style': 'solid'
            'border-color': '#999'
            'cursor': 'not-allowed'
          booking_details = '<div class=\'booking-event\'>' + event.booking_without_promotion + ' of ' + event.booking_without_promotion_total + '<br><span>' + I18n.t('booked') + '</span></div>'
          element.append booking_details
          $(element).find('.booking-event').css
            'background-color': '#634141'
            'text-align': 'center'
            'bottom': '0'
            'position': 'absolute'
            'width': '100%'
            'height': '30%'
            'cursor': 'not-allowed'
        when 'black_out'
          element.find('.fc-content').css
            'background-color': '#31708f'
            'color': '#FFFFFF'
            'border-top-style': 'solid'
            'border-color': '#999'
            'cursor': 'not-allowed'
        else
          element.find('.fc-content').css
            'background-color': '#006da0'
            'color': '#FFFFFF'
            'border-top-style': 'solid'
            'border-color': '#99CC00'

          booking_tag = "
            <div class='booking-wraper'>
              <div class='booking-header'>
              </div>
              <div class='booking-space'>
                <p>"+ (event.booking_without_promotion_total - event.number_bookings_in_current_period)+" SPACES</p>
                <p> $ "+$scope.promo.promotion.price+"</p>
              </div>
            <div class='booking-button'>
              <p>I'm In! <br> Book it!</p>
            </div>
          </div>"

      if event.blackout
        element.find('.fc-bg').css
          'background-color': '#a4a4a4 !important'
        element.find('.fc-event').css
          'cursor': 'not-allowed'
      else
        element.find('.fc-bg').css
          'background-color': '#0099FF'
          'color': '#FFFFFF'

      header = "
      <div class='fc-title-header'>
      </div>"

      toolbar = "
        <div class='mod-tollbar'></div>
      "

      element.find("div.fc-content").prepend(header)
      element.find("div.fc-bg").append(booking_tag)
      element.find(".fc-tollbar").addClass('mod-tollbar')

      if event.blackout
        # If the event is blackout event, Add the corresponding CSS
        $(element).addClass 'blackout_event'
        element.find('.fc-content').css
          'background-color': '#31708f'
          'color': '#FFFFFF'
          'border-top-style': 'solid'
          'border-color': '#999'
          'cursor': 'not-allowed'
        element.find('.fc-bg').css
          'display': 'none'
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
      showWeeks: false
      toggleWeeksText: null
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
        right: ''
      defaultView: 'agendaWeek'
      height: 650
      eventClick: $scope.modalOnEventClick
      eventRender: $scope.eventRender
      eventColor: '#378006'

    # get date from datepicker
    $scope.$watch 'dt', ->
      angular.element('.calendar-overview').fullCalendar('gotoDate', $scope.dt)
      return

    # parsing ui-calender json
    id = $stateParams.activityId
    start_date = moment($scope.dt).format("YYYY-M-d")
    end_date = moment(start_date).endOf('month').format()

    $scope.eventSource =
      #url: '/calendars/get_events?end_date='+end_date+'&id='+id+'&promotion_id='+id+'&start_date='+start_date
      url: '/calendars/get_segmented_events?start_date='+start_date+'&end_date='+end_date+'&promotion_id='+id+'&new_calendar=true'
      cache: false

    $scope.eventSources = [$scope.eventSource]

    # submit reveiw
    $scope.reviewParam = {}
    $scope.submitForm = ->
      obj = 
        content: $scope.reviewParam.content
        rating: $scope.reviewParam.rating
        user_id: gon.current_user.current_user_id
      reviewService.sending(obj).success((res, status) ->
        $scope.reviews.push(res)
        $("#reviewModal").modal('hide')
        Notification.success('Your rate has been created')
        return
      ).error (res, status) ->
        Notification.warning('Something went wrong')

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
        exp_month           = $scope.expiry.substring(0,2)
        exp_year            = $scope.expiry.substring(3,7)
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
          card_type: $scope.cardType
          name_card: ($scope.firstName + $scope.lastName)
          ccard_last4: $scope.number
          exp_month: exp_month
          exp_year: exp_year
          security_code: $scope.csv
          amount: $scope.depositDue
          discount_price: $scope.discountPrice
          regular_price: $scope.regularPrice
        object =
          book_date: $scope.book_date
          start_time: $scope.start_date
          end_time: $scope.end_date
          promotion_id: $stateParams.activityId
          check_discount: true
          promotion_price: 0
          paid_price: amount
          first_name: $scope.firstName
          last_name: $scope.lastName
          email: $scope.email
          phone: $scope.mobile
        discount_price  = $scope.discountPrice
        regular_price   = $scope.regularPrice
        paymentService.chargeSripe(result.id, "", "", obj, object, discount_price, regular_price).success (res, status) ->
          $("#fullCalModal").modal('hide')
          $scope.isHideAmount == false
          $scope.isHideUser == true
          Notification.success('Congratulation You already book this Event')
      return
]
