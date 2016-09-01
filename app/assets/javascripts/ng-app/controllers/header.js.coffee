angular.module('uinApp').controller 'HeaderCtrl', ($scope) ->
	$scope.init = ->
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
      console.log 'header'

	$scope.load = ->
		console.log 'click'
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