angular.module('uinApp').controller 'ActivitiesController', ($scope, activitiesService, Notification) ->
    if localStorage.getItem('search') == null
      localStorage.setItem("search", JSON.stringify({}))
    $scope.itemArray = [{range: "5..25", name: '$5-$25'}, {range: "25..50", name: '$25-$50'}, {range: "50..75", name: '$50-$75'}, {range: "75..100", name: '$75-$100'}, {range: "100..150", name: '$100-$150'}, {range: "150..250", name: '$150-$250'}, {range: "250", name: '$250 & up'}
    ]
    $scope.statePopular = false
    $scope.regionArray = [{code: "AK", name: "AK"},{code: "AL", name: "AL"},{code: "AR", name: "AR"},{code: "AZ", name: "AZ"},{code: "CA", name: "CA"},{code: "CO", name: "CO"},{code: "CT", name: "CT"},{code: "DE", name: "DE"},{code: "FL", name: "FL"},{code: "GA", name: "GA"},{code: "HI", name: "HI"},{code: "IA", name: "IA"},{code: "ID", name: "ID"},{code: "IL", name: "IL"},{code: "IN", name: "IN"},{code: "KS", name: "KS"},{code: "KY", name: "KY"},{code: "LA", name: "LA"},{code: "MA", name: "MA"},{code: "MD", name: "MD"},{code: "ME", name: "ME"},{code: "MI", name: "MI"},{code: "MN", name: "MN"},{code: "MO", name: "MO"},{code: "MS", name: "MS"},{code: "MT", name: "MT"},{code: "NC", name: "NC"},{code: "ND", name: "ND"},{code: "NE", name: "NE"},{code: "NH", name: "NH"},{code: "NJ", name: "NJ"},{code: "NM", name: "NM"},{code: "NV", name: "NV"},{code: "NY", name: "NY"},{code: "OH", name: "OH"},{code: "OK", name: "OK"},{code: "OR", name: "OR"},{code: "PA", name: "PA"},{code: "RI", name: "RI"},{code: "SC", name: "SC"},{code: "SD", name: "SD"},{code: "TN", name: "TN"},{code: "TX", name: "TX"},{code: "UT", name: "UT"},{code: "VA", name: "VA"},{code: "VT", name: "VT"},{code: "WA", name: "WA"},{code: "WI", name: "WI"},{code: "WV", name: "WV"},{code: "WY", name: "WY"}]
    
    activitiesService.fetch({}, 1, $scope.statePopular).then (res, status) ->
      $scope.activities = res.activities
      $scope.next_page = res.next_page

    activitiesService.genre().then (res, status) ->
      $scope.genres = res

    $scope.mostPopular = (statePopular) ->
      obj = JSON.parse(localStorage.getItem("search"))
      if statePopular
        $scope.statePopular = false
      else
        $scope.statePopular = true
      activitiesService.fetch(obj, 1, $scope.statePopular).then (res, status) ->
        $scope.activities = res.activities
        $scope.next_page = res.next_page
        return

    $scope.count = 2
    
    $scope.slides = gon.default_slides
    
    $scope.nextPage = (next_page) ->
      next_page = $scope.count++
      if next_page != null
        obj = JSON.parse(localStorage.getItem("search"))
        activitiesService.fetch(obj, next_page, $scope.statePopular).then (res, status) ->
          $scope.activities = $scope.activities.concat(res.activities)
          $scope.next_page = res.next_page
          return

    $scope.price = (price) ->
      $('#overlay').remove()
      $('.js-ui-select-override .ui-select-placeholder').removeClass 'white-text'
      $('.js-ui-select-override .ui-select-search').attr 'id', 'white-placeholder'
      $('.show-highlight').removeClass 'overlay-placeholder'
      $('.bootstrap-select').removeClass 'overlay-open'
      $('.genre-dropdown').removeClass 'overlay-open'
      obj = JSON.parse(localStorage.getItem("search"))
      if price == undefined
        delete obj["price_range"];
      else
        price_range = price.range
        obj.price_range = price_range
      localStorage.setItem("search", JSON.stringify(obj))
      activitiesService.fetch(obj, 1, $scope.statePopular).then (res, status) ->
        $scope.activities = res.activities
        $scope.next_page = res.next_page
        return

    $scope.city = (event, city) ->
      if event.keyCode == 13
        $('#overlay').remove()
        $('.js-ui-select-override .ui-select-placeholder').removeClass 'white-text'
        $('.js-ui-select-override .ui-select-search').attr 'id', 'white-placeholder'
        $('.show-highlight').removeClass 'overlay-placeholder'
        $('.bootstrap-select').removeClass 'overlay-open'
        $('.genre-dropdown').removeClass 'overlay-open'
        obj = JSON.parse(localStorage.getItem("search"))
        obj.city = city
        localStorage.setItem("search", JSON.stringify(obj))
        activitiesService.fetch(obj, 1, $scope.statePopular).then (res, status) ->
          $scope.activities = res.activities
          $scope.next_page = res.next_page
          return

    $scope.region = (region) ->
      $('#overlay').remove()
      $('.js-ui-select-override .ui-select-placeholder').removeClass 'white-text'
      $('.js-ui-select-override .ui-select-search').attr 'id', 'white-placeholder'
      $('.show-highlight').removeClass 'overlay-placeholder'
      $('.bootstrap-select').removeClass 'overlay-open'
      $('.genre-dropdown').removeClass 'overlay-open'
      obj = JSON.parse(localStorage.getItem("search"))
      if region == undefined
        delete obj["state"];
      else
        obj.state = region.code
      localStorage.setItem("search", JSON.stringify(obj))
      activitiesService.fetch(obj, 1, $scope.statePopular).then (res, status) ->
        $scope.activities = res.activities
        $scope.next_page = res.next_page
        return

    $scope.myGenre = selected: {}

    $scope.zipcode = (event, zipcode) ->
      if event.keyCode == 13
        $('#overlay').remove()
        $('.js-ui-select-override .ui-select-placeholder').removeClass 'white-text'
        $('.js-ui-select-override .ui-select-search').attr 'id', 'white-placeholder'
        $('.show-highlight').removeClass 'overlay-placeholder'
        $('.bootstrap-select').removeClass 'overlay-open'
        $('.genre-dropdown').removeClass 'overlay-open'
        obj = JSON.parse(localStorage.getItem("search"))
        obj.zipcode = zipcode
        localStorage.setItem("search", JSON.stringify(obj))
        activitiesService.fetch(obj, 1, $scope.statePopular).then (res, status) ->
          $scope.activities = res.activities
          $scope.next_page = res.next_page
          return

    $scope.submit = ->
      arr = []
      for key of $scope.myGenre.selected
        if $scope.myGenre.selected[key] == true
          arr.push key
      obj = JSON.parse(localStorage.getItem("search"))
      obj.category_ids = arr
      localStorage.setItem("search", JSON.stringify(obj))
      activitiesService.fetch(obj, 1, $scope.statePopular).then (res, status) ->
        $scope.activities = res.activities
        $scope.next_page = res.next_page
        $scope.count = 2
        return

    $scope.$on '$destroy', ->
      localStorage.removeItem("search")
      return
    
    $scope.$on '$stateChangeSuccess', ->
      jQuery ($) ->
        $('.js-ui-select-override .ui-select-toggle').addClass 'show-highlight'
        $('.js-ui-select-override .ui-select-placeholder').addClass 'show-highlight'
        $('.genre-dropdown').on 'show.bs.dropdown', ->
          $('.show-highlight').addClass 'overlay-placeholder'
          $('.bootstrap-select').addClass 'overlay-open'
          return
        $('.show-highlight').on('click', (e) ->
          if !$('#overlay').length
            $('.js-ui-select-override .ui-select-placeholder').addClass 'white-text'
            $('.js-ui-select-override .ui-select-search').attr 'id', 'white-placeholder'
            $('.show-highlight').addClass 'overlay-placeholder'
            $('body').append '<div id="overlay"> </div>'
            $('.show-highlight').addClass 'overlay-placeholder'
            $('.bootstrap-select').addClass 'overlay-open'
            $('.genre-dropdown').addClass 'overlay-open'
          return
        ).keyup (e) ->
          if e.which == 27
            $('#overlay').remove()
            $('.js-ui-select-override .ui-select-placeholder').removeClass 'white-text'
            $('.js-ui-select-override .ui-select-search').attr 'id', 'white-placeholder'
            $('.show-highlight').removeClass 'overlay-placeholder'
            $('.bootstrap-select').removeClass 'overlay-open'
            $('.genre-dropdown').removeClass 'overlay-open'
          return
        $('body').click (e) ->
          if !$(e.target).is('.show-highlight')
            $('#overlay').remove()
            $('.js-ui-select-override .ui-select-placeholder').removeClass 'white-text'
            $('.js-ui-select-override .ui-select-search').attr 'id', 'white-placeholder'
            $('.show-highlight').removeClass 'overlay-placeholder'
            $('.bootstrap-select').removeClass 'overlay-open'
            $('.genre-dropdown').removeClass 'overlay-open'
          return
        return

    $scope.$on '$stateChangeSuccess', ->
      elem = document.querySelector('input[type="range"]')

      rangeValue = ->
        newValue = elem.value
        target = document.querySelector('.value')
        target.innerHTML = newValue
        return

      elem.addEventListener 'input', rangeValue

      localStorage.setItem 'search', JSON.stringify({})
      $('.btn-close-filter, .btn-save-continue').click ->
        $('#overlay').remove()
        $('.genre-dropdown').removeClass 'overlay-open'
        $('.genre-dropdown').removeClass 'open'
        $('.js-ui-select-override .ui-select-placeholder').removeClass 'white-text'
        $('.js-ui-select-override .ui-select-search').attr 'id', 'white-placeholder'
        $('.show-highlight').removeClass 'overlay-placeholder'
        $('.bootstrap-select').removeClass 'overlay-open'
        return
      return

    $scope.$on '$stateChangeSuccess', ->
      # Dropdown toggle
      $('.dropdown-toggle-humberger').click ->
        $(this).next('.dropdown-humberger').toggle()
        return
      $(document).click (e) ->
        target = e.target
        if !$(target).is('.dropdown-toggle-humberger') and !$(target).parents().is('.dropdown-toggle-humberger')
          $('.dropdown-humberger').hide()
        return
      $('.dropdown-menu').click (event) ->
        event.stopPropagation()
        return

    $scope.$on '$stateChangeSuccess', ->
      url_href = window.location.href.split('/')[3].split('?')[0]
      if url_href != ''
        $('.navbar-right li a').removeClass 'tab-active'
        $('.navbar-right li a').each ->
          if $(this).attr('href').indexOf('/' + url_href) >= 0
            $(this).addClass 'tab-active'
          return
        $('.navbar-nav a.btn').removeClass 'tab-active'
        $('.navbar-nav a.btn[href=\'' + window.location.pathname + '\']').addClass 'tab-active'
      $('.alert').fadeOut 3000
      $('a.scroll-down').click ->
        $('html,body').animate { scrollTop: $('.second').offset().top }, 'slow'
        return
      return

    $scope.bookmarkEvent = (id)->
      promotion_id = id
      activitiesService.bookmark(id).then ((res, status) ->
        Notification.success 'Activities Added To Your Bucket List'
      ), (res, status) ->
        Notification.warning 'You need singin before create Bucket List'