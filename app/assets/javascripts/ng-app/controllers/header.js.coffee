angular.module('uinApp').controller 'HeaderCtrl', [
	'$scope'
  ($scope) ->
	  $scope.$on '$stateChangeSuccess', ->
      $('.dropdown-toggle-humberger').click ->
        $(this).next('.dropdown-humberger').toggle()
        return
      $(document).on "click", '.dropdown-toggle-humberger', (e) ->
        target = e.target
        if !$(target).is('.dropdown-toggle-humberger') and !$(target).parents().is('.dropdown-toggle-humberger')
          $('.dropdown-humberger').hide()
        return
      $('.dropdown-menu').click (event) ->
        event.stopPropagation()
        return
]