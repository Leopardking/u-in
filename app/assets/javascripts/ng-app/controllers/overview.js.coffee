angular.module('uinApp').factory 'reviewService', [
  '$http'
  '$stateParams'
  ($http, $stateParams) ->
    { sending: (obj) ->
      $http.post('/activities/'+ $stateParams.activityId + '/reviews', review: obj)
    }
]

angular.module('uinApp').controller 'overviewsCtrl', [
  '$scope'
  '$http'
  '$stateParams'
  'reviewService'
  'sessionService'
  'uiCalendarConfig'
  '$compile'
  ($scope, $http, $stateParams, reviewService, sessionService, uiCalendarConfig, $compile) ->
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
      $scope.updatePrice = ->
        $scope.totalPrice = ($scope.promotionhash.promotion.price * $scope.regularPrice) + ($scope.promotionhash.promotion.price * $scope.discountPrice)

    $scope.alertOnEventClick = (event, date, jsEvent, view) ->
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

    $scope.inlineOptions =
      customClass: getDayClass
      minDate: new Date
      showWeeks: true

    $scope.dateOptions =
      dateDisabled: disabled
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
      eventClick: $scope.alertOnEventClick
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
]