angular.module('uinApp').controller 'calendarCtrl', [
	'$scope'
  '$compile' 
  'uiCalendarConfig'
  ($scope, $compile, uiCalendarConfig ) ->
    date = new Date
    d = date.getDate()
    m = date.getMonth()
    y = date.getFullYear()
    $scope.changeTo = 'Hungarian'
    
    $scope.eventSource =
      url: 'http://www.google.com/calendar/feeds/usa__en%40holiday.calendar.google.com/public/basic'
      className: 'gcal-event'
      currentTimezone: 'America/Chicago'

    ### event source that contains custom events on the scope ###

    $scope.events = [
      {
        title: 'All Day Event'
        start: new Date(y, m, 1)
      }
      {
        title: 'Long Event'
        start: new Date(y, m, d - 5)
        end: new Date(y, m, d - 2)
      }
      {
        id: 999
        title: 'Repeating Event'
        start: new Date(y, m, d - 3, 16, 0)
        allDay: false
      }
      {
        id: 999
        title: 'Repeating Event'
        start: new Date(y, m, d + 4, 16, 0)
        allDay: false
      }
      {
        title: 'Birthday Party'
        start: new Date(y, m, d + 1, 19, 0)
        end: new Date(y, m, d + 1, 22, 30)
        allDay: false
      }
      {
        title: 'Click for Google'
        start: new Date(y, m, 28)
        end: new Date(y, m, 29)
        url: 'http://google.com/'
      }
    ]

    ### event source that calls a function on every view switch ###

    $scope.eventsF = (start, end, timezone, callback) ->
      `var m`
      s = new Date(start).getTime() / 1000
      e = new Date(end).getTime() / 1000
      m = new Date(start).getMonth()
      events = [ {
        title: 'Feed Me ' + m
        start: s + 50000
        end: s + 100000
        allDay: false
        className: [ 'customFeed' ]
      } ]
      callback events
      return

    $scope.calEventsExt =
      color: '#f00'
      textColor: 'yellow'
      events: [
        {
          type: 'party'
          title: 'Lunch'
          start: new Date(y, m, d, 12, 0)
          end: new Date(y, m, d, 14, 0)
          allDay: false
        }
        {
          type: 'party'
          title: 'Lunch 2'
          start: new Date(y, m, d, 12, 0)
          end: new Date(y, m, d, 14, 0)
          allDay: false
        }
        {
          type: 'party'
          title: 'Click for Google'
          start: new Date(y, m, 28)
          end: new Date(y, m, 29)
          url: 'http://google.com/'
        }
      ]

    ### alert on eventClick ###

    $scope.alertOnEventClick = (date, jsEvent, view) ->
      $scope.alertMessage = date.title + ' was clicked '
      return

    ### alert on Drop ###

    $scope.alertOnDrop = (event, delta, revertFunc, jsEvent, ui, view) ->
      $scope.alertMessage = 'Event Droped to make dayDelta ' + delta
      return

    ### alert on Resize ###

    $scope.alertOnResize = (event, delta, revertFunc, jsEvent, ui, view) ->
      $scope.alertMessage = 'Event Resized to make dayDelta ' + delta
      return

    ### add and removes an event source of choice ###

    $scope.addRemoveEventSource = (sources, source) ->
      canAdd = 0
      angular.forEach sources, (value, key) ->
        if sources[key] == source
          sources.splice key, 1
          canAdd = 1
        return
      if canAdd == 0
        sources.push source
      return

    ### add custom event###

    $scope.addEvent = ->
      $scope.events.push
        title: 'Open Sesame'
        start: new Date(y, m, 28)
        end: new Date(y, m, 29)
        className: [ 'openSesame' ]
      return

    ### remove event ###

    $scope.remove = (index) ->
      $scope.events.splice index, 1
      return

    ### Change View ###

    $scope.changeView = (view, calendar) ->
      uiCalendarConfig.calendars[calendar].fullCalendar 'changeView', view
      return

    ### Change View ###

    $scope.renderCalender = (calendar) ->
      if uiCalendarConfig.calendars[calendar]
        uiCalendarConfig.calendars[calendar].fullCalendar 'render'
      return

    ### Render Tooltip ###

    $scope.eventRender = (event, element, view) ->
      element.attr
        'tooltip': event.title
        'tooltip-append-to-body': true
      $compile(element) $scope
      return

    ### config object ###

    $scope.uiConfig = calendar:
      height: 450
      editable: true
      header:
        left: 'title'
        center: ''
        right: 'today prev,next'
      eventClick: $scope.alertOnEventClick
      eventDrop: $scope.alertOnDrop
      eventResize: $scope.alertOnResize
      eventRender: $scope.eventRender

    $scope.changeLang = ->
      if $scope.changeTo == 'Hungarian'
        $scope.uiConfig.calendar.dayNames = [
          'Vasárnap'
          'Hétfő'
          'Kedd'
          'Szerda'
          'Csütörtök'
          'Péntek'
          'Szombat'
        ]
        $scope.uiConfig.calendar.dayNamesShort = [
          'Vas'
          'Hét'
          'Kedd'
          'Sze'
          'Csüt'
          'Pén'
          'Szo'
        ]
        $scope.changeTo = 'English'
      else
        $scope.uiConfig.calendar.dayNames = [
          'Sunday'
          'Monday'
          'Tuesday'
          'Wednesday'
          'Thursday'
          'Friday'
          'Saturday'
        ]
        $scope.uiConfig.calendar.dayNamesShort = [
          'Sun'
          'Mon'
          'Tue'
          'Wed'
          'Thu'
          'Fri'
          'Sat'
        ]
        $scope.changeTo = 'Hungarian'
      return

    ### event sources array###

    $scope.eventSources = [
      $scope.events
      $scope.eventSource
      $scope.eventsF
    ]
    $scope.eventSources2 = [
      $scope.calEventsExt
      $scope.eventsF
      $scope.events
    ]
    return
]