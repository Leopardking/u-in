app = angular.module('uinApp', [
  'ui.router'
  'templates'
  'ui.select'
  'ui.bootstrap'
  'ng-rails-csrf'
  'ngRateIt'
  'Devise'
  'ui.calendar'
  'angular-moment'
  'angularPayments'
  'angular-stripe'
  'angular-flexslider'
])

#Stripe.setPublishableKey 'pk_test_GV5ggkXJsOFMFLqyIR3gCScj'

app.service 'sessionService', [ '$window', ($window)->

  factory =
    current_user: ->
      $window.gon.current_user

  factory
]

app.config([
  '$stateProvider'
  '$urlRouterProvider'
  'AuthProvider'
  'stripeProvider'
  ($stateProvider, $urlRouterProvider, AuthProvider, stripeProvider) ->
    $stateProvider
    .state('home',
      url: '/'
      templateUrl: 'activities/index.html'
      controller: 'ActivitiesCtrl')
    .state('activities',
      url: '/activities'
      templateUrl: 'activities/index.html'
      controller: 'ActivitiesCtrl')
    .state('overview',
      url: '/activities/:activityId'
      templateUrl: 'activities/show.html'
      controller: 'overviewsCtrl')
    # default fall back route
    $urlRouterProvider.otherwise '/'
    # enable HTML5 Mode for SEO
    # $locationProvider.html5Mode true
    return
])