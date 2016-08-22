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
//= require moment.js
//= require fullcalendar.js
//= require bootstrap-datetimepicker
//= require datepicker.js
//= require timepicker.js
//= require jquery.remotipart
//= require jquery.maskMoney.js
//= require jquery.maskedinput.min.js
//= require validation_add_method.js
//= require placeholder_custom.js
//= require bootstrap-slider.js
//= require jquery.tooltipster.min.js
//= require js-routes
//= require SocialShare.min
//= require prototype
//= require promotions_new.js
//= require promotion_social_share.js
//= require edit_profile.js
//= require contact_us.js
//= require jquery.nicescroll.min.js
//= require scheduling_promotion.js
//= require validation_add_method
//= require common.js
//= require calendars.js
//= require stripe_process
//= require constants
//= require jquery.Jcrop.min.js
//= require common.js
//= require crop_image
//= require global
//= require jquery.blockUI
//= require responsiveslides

$( document ).ready(function() {
  $("body").delegate(".back_arrow","click", function(){
    $(".promotion-form").validate().settings.ignore = "*";
    if($("#basic_information").hasClass("complete-dot")){
      $("#back_button").val(true);
      $(".promotion-form").submit();
  	}
  });

  // Custom select dropdown functionality
  $(".custom-select").each(function(){
    $(this).after("<span class='holder'></span>");
  });

  $(".custom-select").change(function(){
    var selectedOption = $(this).find(":selected").text();
    $(this).next(".holder").text(selectedOption);
  }).trigger('change');
  $(".alert").fadeOut(3000)
});


function scroll_bar (slider , type){
  var value = slider.getValue();
  // For non-getter methods, you can chain together commands
  if(type == "next") {
    slider.setValue(value + 1);
  }
  else{
    slider.setValue(value - 1);
  }
};
