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
};

$(function () {
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
});

jQuery(function ($) {
    $(".show-highlight").on('click', function (e) {
        if (!$('#overlay').length) {
            $('body').append('<div id="overlay"> </div>')
        }
    }).keyup(function (e) {
        if (e.which == 27) {
            $('#overlay').remove();
        }
    }).blur(function (e) {
        $('#overlay').remove();
    });
    $('body').click(function (e) {
        if (!$(e.target).is('.show-highlight')) {
            $('#overlay').remove();
        }
    })
});

$(function () {
  var elem = document.querySelector('input[type="range"]');
  var rangeValue = function(){
    var newValue = elem.value;
    var target = document.querySelector('.value');
    target.innerHTML = newValue;
  }

  elem.addEventListener("input", rangeValue);
});

$(function() {

// Dropdown toggle
$('.dropdown-toggle-humberger').click(function(){
  $(this).next('.dropdown-humberger').toggle();
});

$(document).click(function(e) {
  var target = e.target;
  if (!$(target).is('.dropdown-toggle-humberger') && !$(target).parents().is('.dropdown-toggle-humberger')) {
    $('.dropdown-humberger').hide();
  }
});

});