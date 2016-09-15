// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.cookie
//= require jstz
//= require browser_timezone_rails/set_time_zone
//= require i18n
//= require i18n/translations
//= require jquery.validate
//= require moment
//= require bootstrap-datetimepicker
//= require datepicker.js
//= require jquery.remotipart
//= require jquery.maskMoney.js
//= require jquery.maskedinput.min.js
//= require jquery.tooltipster.min.js
//= require js-routes
//= require prototype
//= require activities.js
//= require book_js.js
//= require categories.js
//= require routes.js
//= require validation_add_method.js
//= require common.js
//= require placeholder_custom.js
//= require scrollbar.js
//= require edit_profile.js
//= require contact_us.js
//= require global
//= require responsiveslides
//= require bootstrap-select
//= require jquery.flexslider
//= require angular
//= require angular-ui-router
//= require angular-rails-templates
//= require angular-ui-select
//= require ng-app/app
//= require_tree ./ng-app/controllers
//= require_tree ../templates
//= require angular-ui-bootstrap
//= require angular-ui-bootstrap-tpls
//= require ng-rails-csrf
//= require ng-rateit.js
//= require angular-devise
//= require angular-momentjs
//= require calendar
//= require fullcalendar
//= require angular-payments
//= require angular-stripe
//= require angular-flexslider

window.onload = function() {
  url_href = window.location.href.split("/")[3].split("?")[0]
  if(url_href != ""){
    $(".navbar-right li a").removeClass("tab-active");
      $(".navbar-right li a").each(function(){
      if($(this).attr("href").indexOf("/"+url_href) >= 0){
      $(this).addClass('tab-active')
      }
    });

    $(".navbar-nav a.btn").removeClass("tab-active")
    $(".navbar-nav a.btn[href='"+window.location.pathname+"']").addClass("tab-active")
  }
  $(".alert").fadeOut(3000)

  $("a.scroll-down").click(function() {
  $('html,body').animate({
      scrollTop: $(".second").offset().top},
      'slow');
  });
};

jQuery(function ($) {
    $(".js-ui-select-override .ui-select-toggle").addClass('show-highlight');
    $(".js-ui-select-override .ui-select-placeholder").addClass('show-highlight');
    $('.genre-dropdown').on('show.bs.dropdown', function () {
      $(".show-highlight").addClass('overlay-placeholder');
      $(".bootstrap-select").addClass('overlay-open');
    })
    $(".show-highlight").on('click', function (e) {
        if (!$('#overlay').length) {
            $(".js-ui-select-override .ui-select-placeholder").addClass('white-text');
            $(".js-ui-select-override .ui-select-search").attr('id', 'white-placeholder');
            $(".show-highlight").addClass('overlay-placeholder');
            $('body').append('<div id="overlay"> </div>');
            $(".show-highlight").addClass('overlay-placeholder');
            $(".bootstrap-select").addClass('overlay-open');
            $(".genre-dropdown").addClass('overlay-open');
        }
    }).keyup(function (e) {
        if (e.which == 27) {
            $('#overlay').remove();
            $(".js-ui-select-override .ui-select-placeholder").removeClass('white-text');
            $(".js-ui-select-override .ui-select-search").attr('id', 'white-placeholder');
            $(".show-highlight").removeClass('overlay-placeholder');
            $(".bootstrap-select").removeClass('overlay-open');
            $(".genre-dropdown").removeClass('overlay-open');
        }
    });
    $('body').click(function (e) {
        if (!$(e.target).is('.show-highlight')) {
            $('#overlay').remove();
            $(".js-ui-select-override .ui-select-placeholder").removeClass('white-text');
            $(".js-ui-select-override .ui-select-search").attr('id', 'white-placeholder');
            $(".show-highlight").removeClass('overlay-placeholder');
            $(".bootstrap-select").removeClass('overlay-open');
            $(".genre-dropdown").removeClass('overlay-open');
        };
    });
});

$(document).ready(function(){
  if (document.location.hash.includes("#/activities")){
     setTimeout(function(){
          $("#slider4").responsiveSlides({
            auto: true,
            pager: false,
            nav: true,
            speed: 500,
            namespace: "callbacks",
            before: function () {
              $('.events').append("<li>before event fired.</li>");
            },
            after: function () {
              $('.events').append("<li>after event fired.</li>");
            }
          });
     },1000);
  }
});

$( document ).ready(function() {
  var elem = document.querySelector('input[type="range"]');
  var rangeValue = function(){
    var newValue = elem.value;
    var target = document.querySelector('.value');
    target.innerHTML = newValue;
  }

  elem.addEventListener("input", rangeValue);
  $("#slider4").responsiveSlides({
      auto: true,
      pager: false,
      nav: true,
      speed: 500,
      namespace: "callbacks",
      before: function () {
        $('.events').append("<li>before event fired.</li>");
      },
      after: function () {
        $('.events').append("<li>after event fired.</li>");
      }
  });

  // Dropdown toggle

  $('.dropdown-toggle-humberger').click(function(){
    $(this).next('.dropdown-humberger').toggle();
  });

  $(document).on("click", '.dropdown-toggle-humberger', function(e){
    var target = e.target;
    if (!$(target).is('.dropdown-toggle-humberger') && !$(target).parents().is('.dropdown-toggle-humberger')) {
      $('.dropdown-humberger').hide();
    }
  });

  $(".dropdown-menu").click(function(event){
    event.stopPropagation()
  })

  localStorage.setItem("search", JSON.stringify({}))

  $(".btn-close-filter, .btn-save-continue").click(function(){
    $('#overlay').remove();
    $(".genre-dropdown").removeClass('overlay-open');
    $(".genre-dropdown").removeClass('open');
    $(".js-ui-select-override .ui-select-placeholder").removeClass('white-text');
    $(".js-ui-select-override .ui-select-search").attr('id', 'white-placeholder');
    $(".show-highlight").removeClass('overlay-placeholder');
    $(".bootstrap-select").removeClass('overlay-open');
  })
});

