app = angular.module('uinApp', [
  'ngResource'
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
  'angular-loading-bar'
  'angularValidator'
  'ui-notification'
  'ngFileUpload'
  'ngImgCrop'
])

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
  'cfpLoadingBarProvider'
  ($stateProvider, $urlRouterProvider, AuthProvider, stripeProvider, cfpLoadingBarProvider) ->
    cfpLoadingBarProvider.parentSelector = '#loading-bar-container'
    cfpLoadingBarProvider.latencyThreshold = 10
    $stateProvider
    .state('home',
      url: '/'
      templateUrl: 'ng-app/templates/activities/index.html'
      controller: 'ActivitiesController')
    .state('myActivities',
      url: '/my-activity'
      templateUrl: 'ng-app/templates/myactivity/show.html'
      controller: 'MyActivityController')
    .state('overview',
      url: '/activities/:activityId'
      templateUrl: 'ng-app/templates/activities/show.html'
      controller: 'overviewsController')
    # default fall back route
    $urlRouterProvider.otherwise '/'
    # enable HTML5 Mode for SEO
    # $locationProvider.html5Mode true
    return
])