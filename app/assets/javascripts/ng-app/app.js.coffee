angular.module('uinApp', [
  'ui.router'
  'templates'
]).config ($stateProvider, $urlRouterProvider, $locationProvider) ->
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