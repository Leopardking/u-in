app = angular.module('uinApp', [
  'ui.router'
  'templates'
  'ui.select'
  'ui.bootstrap'
])

app.config([
  '$stateProvider'
  '$urlRouterProvider'
  ($stateProvider, $urlRouterProvider) ->
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