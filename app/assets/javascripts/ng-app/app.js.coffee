app = angular.module('uinApp', [
  'ui.router'
  'templates'
  'ui.select'
])

app.config([
  '$stateProvider'
  '$urlRouterProvider'
  ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state('home',
      url: '/'
      templateUrl: 'home.html'
      controller: 'HomeCtrl')
    .state('activities',
      url: '/activities'
      templateUrl: 'activities/index.html'
      controller: 'ActivitiesCtrl')
    # default fall back route
    $urlRouterProvider.otherwise '/'
    # enable HTML5 Mode for SEO
    # $locationProvider.html5Mode true
    return
])