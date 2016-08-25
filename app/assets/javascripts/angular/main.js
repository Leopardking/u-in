angular
 .module('uin', ['ui.router', 'templates'])
 .config(function($stateProvider, $urlRouterProvider) {
   // $stateProvider
   //   .state('home', {
   //     url: '/',
   //     templateUrl: 'home.html',
   //     controller: 'ActivityController as ctrl'
   //   }),

   $stateProvider
     .state('activities', {
       url: '/activities',
       templateUrl: 'home.html',
       controller: 'ActivityController as ctrl'
     })
  $urlRouterProvider.otherwise('/');
});


// "use strict";

// var app = angular.module('Uin', [
//   'templates',
//   'ngResource'
//   'ui.router'
// ]);


// app.config(function($stateProvider, $urlRouterProvider) {
//    $urlRouterProvider.otherwise('/');

//    $stateProvider
//      .state('home', {
//        url: 'activities',
//        templateUrl: 'home.html',
//        controller: 'ActivityController'
//      })
// });