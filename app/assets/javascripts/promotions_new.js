  window.Pages['PromotionPage'] = {
  init: function(){
    this.bindPriceSilder();
    this.initCurrentRankOfPromotion(this.promotionID);
    this.removeValueGoogleMap();
  },
  bindPriceSilder: function(){
    if ($("#priceDiscount").length){
      var myslider = $("#priceDiscount").slider({
        step: 0.5,
        natural_arrow_keys:true,
        min: 0,
        max: 100,
        value: 50,
        "orientation":  "vertical",
      }).on('slide change', function(_ev) {
        if (_ev.type == "slide"){
          $("#promotion_discount_percent").val(100 - _ev.value);
          $(".discount_percent_first").html(100 - _ev.value);
        } else if (_ev.type == "change") {
          $("#promotion_discount_percent").val(100 - _ev.value.newValue);
          $(".discount_percent_first").html(100 - _ev.value.newValue);
        }
      });

      $("#promotion_discount_price").on("keyup", function(e){
        var price=Number($('#promotion_price').val().replace(/[^0-9\.]+/g,""));
        var discount_price = Number($('#promotion_discount_price').val().replace(/[^0-9\.]+/g,""));
        var discount_percent = (price - discount_price)/price * 100;
        var discount_percent_first = discount_percent.toFixed(2);
        var canellation_price = Number($('#promotion_cancellation_fee').val().replace(/[^0-9\.]+/g,""));
        $('#promotion_cancellation_fee').val(canellation_price.toFixed(2));
        if ($.isNumeric(discount_percent) && discount_percent > 0) {
          // use trigger('mask.maskMoney') to format money for input
          $('#promotion_price').val(price.toFixed(2)).trigger('mask.maskMoney');
          $('#promotion_discount_price').val(discount_price.toFixed(2)).trigger('mask.maskMoney');
          $("#promotion_discount_percent").val(discount_percent.toFixed(2)).trigger('mask.maskMoney');
          $(".discount_percent_first").html(discount_percent_first);
          $(myslider).slider("setValue", 100 - parseInt(discount_percent.toFixed(2)));
        };
      }).trigger("keyup");

      $('#promotion_price').on('keyup', function () {
        var price=Number($('#promotion_price').val().replace(/[^0-9\.]+/g,""));
        var discount_percent = $('#promotion_discount_percent').val();
        var discount_price = price - price*discount_percent/100;
        var canellation_price = Number($('#promotion_cancellation_fee').val().replace(/[^0-9\.]+/g,""));
        $('#promotion_cancellation_fee').val(canellation_price.toFixed(2));
        $('#promotion_price').val(price.toFixed(2)).trigger('mask.maskMoney');
        $("#promotion_discount_price").val(discount_price.toFixed(2)).trigger('mask.maskMoney');
        $(".discount_percent_first").html(discount_percent);
      });

      $("#promotion_discount_percent").on("keyup", function(e) {
        var price = Number($('#promotion_price').val().replace(/[^0-9\.]+/g,""));
        var discount_percent = Number($('#promotion_discount_percent').val().replace(/[^0-9\.]+/g,""))
        var discount_percent_first = discount_percent.toFixed(2);
        var discount_price = price - ((price*discount_percent_first)/100)
        var canellation_price = Number($('#promotion_cancellation_fee').val().replace(/[^0-9\.]+/g,""));
        $('#promotion_cancellation_fee').val(canellation_price.toFixed(2));
        if ($.isNumeric(discount_price) && discount_price > 0) {
          $('#promotion_price').val(price.toFixed(2)).trigger('mask.maskMoney');
          $("#promotion_discount_price").val(discount_price.toFixed(2)).trigger('mask.maskMoney');
          $(".discount_percent_first").html(discount_percent_first);
          $("#priceDiscount").slider("setValue", 100 - parseInt(discount_percent));
        };
      });

      $("#priceDiscount").on("slide change", function(){
        var price=Number($('#promotion_price').val().replace(/[^0-9\.]+/g,""));
        var discount_percent = $('#promotion_discount_percent').val();
        var discount_price = price - price*discount_percent/100;
        var canellation_price = Number($('#promotion_cancellation_fee').val().replace(/[^0-9\.]+/g,""));
        $('#promotion_cancellation_fee').val(canellation_price.toFixed(2));
        $('#promotion_price').val(price.toFixed(2)).trigger('mask.maskMoney');
        $("#promotion_discount_price").val(discount_price.toFixed(2)).trigger('mask.maskMoney');
      });
    }
  },

  disableButtonSaveImage: function(){
    $(".btn-hightlight-color").on("click", function() {
      var get_text = $(this).text()
      if (get_text == "Change") {
        $(".modal-footer input[type='submit']").attr("disabled", true);
        $("#image_image").on("change", function(){
          var fileExtension = ['jpeg', 'png', 'jpg'];
          if ($.inArray($(this).val().split('.').pop().toLowerCase(), fileExtension) == -1) {
            $('#image_image').val("");
            $("#error-message-image-type").modal("show");
            $(".modal-footer input[type='submit']").attr("disabled", true);
          } else {
            $(".modal-footer input[type='submit']").attr("disabled", false);
          }
          var value_image = $('#image_image').val();
          if (value_image.length > 0) {
            $(".modal-footer input[type='submit']").attr("disabled", false);
          } else {
            $(".modal-footer input[type='submit']").attr("disabled", true);
          }
        });
      }
      var get_value_attr = $(this).attr("default_image");
      if (get_value_attr == "false") {
        $(":checked").prop('checked', false);
      } else if (get_value_attr == "true") {
        $(":checked").prop('checked', true);
      }
    });
  },

  validate_image_upload: function() {
    var _URL = window.URL || window.webkitURL;
    $("#image_image").change(function(e) {
      var fileExtension = ['jpeg', 'png', 'jpg'];
      if ($.inArray($(this).val().split('.').pop().toLowerCase(), fileExtension) == -1) {
        $('#image_image').val("");
        $("#error-message-image-type").modal("show");
        $(".modal-footer input[type='submit']").attr("disabled", true);
      } else {
        $(".modal-footer input[type='submit']").attr("disabled", false);
      }
    });
  },

  initCurrentRankOfPromotion: function(promotionID){
    // get current rank
    $('.promotion-form .get_current_rank').off('click').on('click',function(event){
      getCurrentRankOfPromotions(promotionID)
    });
  },

  removeValueGoogleMap: function() {
    $("#promotion_street_address_1, #promotion_city").on("change", function() {
      $("#promotion_google_map_link").val("");
    })
  },

  removeModalUploadImage: function() {
    $("#turnoff-upload-image").on("click", function() {
      $("#upload_image").modal('hide');
      $("#upload_image, .modal-backdrop").remove();
    })
  },

  getDefaultImageStep3: function(selectElem, valueElem) {
    $("#hidden_value_image").html('<input id="data_image_mak" type="hidden" value="'+ valueElem +'" name="collected_input">');
    $("#hidden_image_no").html('<input id="data_image_no" type="hidden" value="1" name="image[image_no]">');
    $("#image_description_image").val($(".open-upload-modal").attr("data-desc"));
    $("#image_image_default").prop("checked", $.parseJSON($(selectElem + "-" + valueElem).attr("data-default")));
    if ($.parseJSON($(selectElem + "-" + valueElem).attr("data-default"))) {
      $("#image_image_default").prop("readonly", true);
    } else {
      $("#image_image_default").prop("readonly", false);
    }
    $("#upload_image").modal("show");
  },

  buttonUploadImagePromotion: function() {
    $("#change-file-image").on("click", function() {
        $("#image_image").click();
    });
  },

  applySildeImagePromotion: function() {
    $(".rslides").responsiveSlides({
      auto: true,
      pager: false,
      nav: true,
      namespace: "callbacks",
      before: function () {},
      after: function () {}
    });
  }
}

function formatCurrency(){
  $('#promotion_price').maskMoney({allowNegative: true, thousands:',', decimal:'.'});
  $('#promotion_discount_price').maskMoney({allowNegative: true, thousands:',', decimal:'.'});
  $('#promotion_cancellation_fee').maskMoney({allowNegative: true, thousands:',', decimal:'.'});
}

function getCurrentRankOfPromotions(promotionID){
    var discount_percent = Number($('#promotion_discount_percent').val());
    var discount_price = Number($('#promotion_discount_price').val());
    var price = Number($('#promotion_price').val());
    var discount = price - discount_price;
    if (discount_percent.length == 0) { return };
    var category_ids = $("#category_current").data().categoryIds;
    $.ajax({
      url: Routes.get_current_rank_promotions_path(),
      data: {
        id: promotionID,
        discount_percent: discount_percent,
        discount: discount,
        category_ids: category_ids
      },
      method: "POST",
      success: function(data){
        $('#promotion_current_rank').val(data.current_rank);
        $("#show_current_rank_init").addClass('hide');
        $('#show_current_rank').removeClass('hide');
        $('#show_current_rank .show_current_rank_value').html(data.current_rank)
        $('#show_current_rank .show_total_ranks').html(data.total_rank)
      }
    });
  }

function parse_currency_to_float() {
  if($('#promotion_price').length > 0){
    $('#promotion_price').val(Number($('#promotion_price').val().replace(/[^0-9\.]+/g,"")));
    $('#promotion_discount_price').val(Number($('#promotion_discount_price').val().replace(/[^0-9\.]+/g,"")));
    $('#promotion_discount_percent').val(Number($('#promotion_discount_percent').val().replace(/[^0-9\.]+/g,"")));
    var price = Number($('#promotion_price').val().replace(/[^0-9\.]+/g,""));
    var discount_price = Number($('#promotion_discount_price').val().replace(/[^0-9\.]+/g,""));
    var saving_price = price - discount_price;
    $("#promotion_saving_price").val(saving_price.toFixed(2));
  }
  if($("#promotion_cancellation_fee").length > 0){
    $('#promotion_cancellation_fee').val(Number($('#promotion_cancellation_fee').val().replace(/[^0-9\.]+/g,"")));
  }
};

function promotion_validation() {
  $(".promotion-form").validate({
    rules: {
      "promotion[name]": {
        required: true,
        maxlength: 60,
        minlength: 2
      },
      "promotion[description]": {
        required: true,
        maxlength: 2000,
        minlength: 2
      },
      "promotion[bring_item]": {
        maxlength: 500,
        minlength: 2
      },
      "promotion[expect]": {
        maxlength: 500,
        minlength: 2
      },
      "promotion[category_ids][]": {
        required: function(elem)
        {
          return $("#promotion_category_ids_:checked").length == 0;
        }
      },
      "promotion[street_address_1]": {
        required: true,
        minlength: 2
      },
      "promotion[city]": {
        required: true,
        minlength: 2
      },
      "promotion[state]": {
        required: true,
        minlength: 2
      },
      "promotion[zipcode]": {
        required: true,
        zipcode: true,
      },
      "promotion[phone_number]": {
        required: true,
        phone: true
      },
      "promotion[google_map_link]": {
        required: true,
        checkLinkGoogleMap: true
      },
      "promotion[price]": {
        required: true
      },
      "promotion[discount_percent]": {
        required: true,
        number: true,
        range: [1, 100]
      },
      "promotion[discount_price]": {
        required: true,
        less_than: '#promotion_price'
      },
      "promotion[start_date]": {
        required: true,
        dateBefore: '#promotion_end_date',
        day_in_past: true
      },
      "promotion[end_date]": {
        required: function(elem)
        {
           return $("#promotion_end_date_type option:selected").val() == 2;
        },
        dateAfter: '#promotion_start_date',
        day_in_past: true
      },
      "promotion[start_time]": {
        required: true,
        timeBefore: '#promotion_end_time',
      },
      "promotion[end_time]": {
        required: true,
        timeAfter: '#promotion_start_time'
      },
      "promotion[frequency]": {
        required: true,
        number: true
      },
      "promotion[end_date_type]": {
        required: true,
      },
      "promotion[days_of_week]": {
        required: function(elem){
          return $("#promotion_repeat option:selected").val() == "Weekly"
        }
      },
      "promotion[booking_detail_attributes][maximum_bookings]": {
        required: true,
        number: true
      },
      "promotion[booking_detail_attributes][booking_criterion]": {
        required: true,
        number: true
      },
      "promotion[booking_detail_attributes][booking_duration]": {
        required: true,
        number: true,
        segmentable: true
      },
      "promotion[booking_detail_attributes][bookings_per_duration]": {
        required: true,
        number: true
      },
      "promotion[cancellation_fee]": {
        required: false
      },
      "promotion[cancellation_minimum]": {
        required: function(elem)
          {
            return ($("#promotion_cancellation_fee").val() != "" && $("#promotion_cancellation_fee").val() > 0)
          },
        number: true,
        range: [1,168]

      },
      "promotion[booking_criterion]": {
        required: true,
        less_than: "#bookings_per_duration"
      },
      "promotion[repeat]": {
        required: true
      },
      "promotion[occurrence]": {
        required: true
      },
      "promotion[repeat]": {
        required: true
      },
      "promotion[end_date_type]": {
        required: true
      },
    },
    messages: {
      "promotion[name]": {
        required: I18n.t("promotions.validation.name"),
        maxlength: I18n.t("promotions.validation.name_length"),
        minlength: I18n.t("promotions.validation.minimum_lenght")
      },
      "promotion[description]": {
        required: I18n.t("promotions.validation.description"),
        maxlength: I18n.t("promotions.validation.description_length"),
        minlength: I18n.t("promotions.validation.minimum_lenght")
      },
      "promotion[bring_item]": {
        maxlength: I18n.t("promotions.validation.bring_length"),
        minlength: I18n.t("promotions.validation.minimum_lenght")
      },
      "promotion[expect]": {
        maxlength: I18n.t("promotions.validation.expect_length"),
        minlength: I18n.t("promotions.validation.minimum_lenght")
      },
      "promotion[category_ids][]": {
        required: I18n.t("promotions.validation.categories")
      },
      "promotion[street_address_1]": {
        required: I18n.t("promotions.validation.street_address_1"),
        minlength: I18n.t("promotions.validation.minimum_lenght")
      },
      "promotion[city]": {
        required: I18n.t("promotions.validation.city"),
        minlength: I18n.t("promotions.validation.minimum_lenght")
      },
      "promotion[state]": {
        required: I18n.t("promotions.validation.state"),
        minlength: I18n.t("promotions.validation.minimum_lenght")
      },
      "promotion[zipcode]": {
       required: I18n.t("promotions.validation.zipcode"),
       number: I18n.t("promotions.validation.zipcode_number")

      },
      "promotion[phone_number]": {
        required: I18n.t("promotions.validation.phone_number"),
        number: I18n.t("promotions.validation.phone_number_type")
      },
      "promotion[google_map_link]": {
        require: I18n.t("promotions.validation.google_map_link")
      },
      "promotion[price]": {
        required: I18n.t("promotions.validation.price"),
        min: I18n.t("promotions.validation.price_min")
      },
      "promotion[discount_percent]": {
        required: I18n.t("promotions.validation.discount_percent"),
        number: I18n.t("promotions.validation.discount_percent_number")
      },
      "promotion[discount_price]": {
        required: I18n.t("promotions.validation.discount_price")
      },
       "promotion[start_date]": {
        required: I18n.t("promotions.validation.start_date")
      },
      "promotion[end_date]": {
        required: I18n.t("promotions.validation.end_date")
      },
      "promotion[days_of_week]": {
        required: I18n.t("promotions.validation.days_of_week")
      },
      "promotion[booking_detail_attributes][maximum_bookings]": {
        required: I18n.t("promotions.validation.booking_available"),
        number: I18n.t("promotions.validation.booking_available_number")
      },
      "promotion[cancellation_fee]": {
        required: I18n.t("promotions.validation.discount_price")
      },
      "promotion[working_schedule_ids][]": {
        required: I18n.t("promotions.validation.segment_err")
      },
      "promotion[frequency]": {
        number: "The value must be a number"
      },
      "promotion[booking_duration]": {
        number: I18n.t("promotions.validation.booking_available_number"),
        segmentable: "Must be less than promotion duration"
      },
      "promotion[bookings_per_duration]": {
        number: I18n.t("promotions.validation.booking_available_number")
      },
      "promotion[cancellation_minimum]": {
        number: I18n.t("promotions.validation.booking_available_number")
      }
    },
    errorPlacement: function (error, element) {
      if(element.attr('name') == 'promotion[category_ids][]'){
        $(".promotion-form").find('.show_error_must_choose_a_categorie').html(error)
      }else if(element.attr('name') == 'promotion[repeat]'){
        $(".promotion-form").find('.select_wrapper_repeat').html(error)
      }else if(element.attr('name') == 'promotion[end_date_type]'){
        $(".promotion-form").find('.select_wrapper_end_date_type').html(error)
      }else if(element.attr('name') == 'promotion[booking_detail_attributes][booking_criterion]'){
        $(".promotion-form").find('.select_wrapper_booking_field').html(error)
      }else if(element.attr('name') == 'promotion[booking_detail_attributes][booking_duration]'){
        $(".promotion-form").find('.select_wrapper_booking_duration').html(error)
      }else if(element.attr('name') == 'promotion[discount_percent]'){
        error.appendTo($(".promotion-form").find('.group-percent-discount'));
      }else if(element.attr('name') == 'promotion[price]'){
        error.appendTo($(".promotion-form").find('.group-regular-price'));
      }else if(element.attr('name') == 'promotion[discount_price]'){
        error.appendTo($(".promotion-form").find('.group-discount-price'))
      }else {
        error.insertAfter(element);
      }
    },
    onkeyup: false,
    ignore: ":hidden",
    highlight: function (element) {
      $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
    },
    unhighlight: function (element) {
      $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
    }
  });
};

// Request category form
function category_validation() {
  $("#suggestcatrForm").validate({
    rules: {
      "category[first_name]": {
        required: true
      },
      "category[last_name]": {
        required: true
      },
      "category[company_name]": {
        required: true
      },
      "category[email]": {
        required: true,
        email: true
      },
      "category[suggest_catr]": {
        required: true
      },
    },
    errorPlacement: function(error, element) {
      error.appendTo(element.parent());
    },
    onfocusout: function(element) {
      this.element(element);
    },
    onkeyup: false,
    ignore: ":hidden",
    highlight: function (element) {
      $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
    },
    unhighlight: function (element) {
      $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
    }
  });
};

$(document).ready(function(){
  moment().format();
  formatCurrency();
  promotion_validation();
  // validate form with new promotion
  $('#new_promotion_form input,#edit_promotion_form input').change(function(){
    $(this).valid();
  });
  // function get google map link
  function get_link_google_map(){
    map_src = "https://www.google.com/maps/embed/v1/place?q="+$("#promotion_street_address_1").val()
                    +" "
                    +$("#promotion_city").val();
    map_src += "&key="+google_map_key+"";
    $("#promotion_google_map_link").val(map_src);
  }
  // Same as business address
  $("#promotion_same_as_business_address").change(function() {
    $("#promotion_google_map_link").val("");
    // $(this) will contain a reference to the checkbox
    if ($(this).is(':checked')) {
      $.ajax({
        url: "/users/"+$("#user_id").val()+"/business_address",
        success: function(data){
          if (data.merchant_detail != null) {
            $(".may_disable").siblings(".error").remove();
            $(".may_disable").parent().removeClass("has-error");
            $("#promotion_street_address_1").val(data.merchant_detail.street_address);
            $("#promotion_city").val(data.merchant_detail.city);
            $("#promotion_state").val(data.merchant_detail.state);
            $("#promotion_zipcode").val(data.merchant_detail.zipcode);
            $(".may_disable").attr('readonly',true);
          }
          $("#promotion_phone_number").val(data.user_detail.phone_number);
          get_link_google_map();
        }
      })
    } else {
       $(".may_disable").attr('readonly', false);
    }
  });
  $("#continue_step2").click(function(){
    get_link_google_map();
    $('.promotion-form').submit();
  });
  if ($("#promotion_same_as_business_address").is(':checked')) {
    $(".may_disable").attr('readonly',true);
  }

  $("form.promotion-form").on('submit', function (e) {
    parse_currency_to_float()

    if(!($("#promotion_repeat option:selected").val() == "Weekly")){
      $("#days").val("")
    }

    // remove onbeforeunload event on form submit
    if(!$(".promotion-form").valid() || ($("#promotion_repeat option:selected").val() == "Weekly" && $("#days").val() ==  ""))
    {
      if($("#days").val() ==  "")
      $("#weekly_fields").append('<label for="days" class="error" style="display: block;">Please choose a day</label>')
      e.preventDefault();
    }
  });

  // GoogleMap popup
  $("#prevbtn").click(function(){
    if($("#promotion_google_map_link").val() == ""){
      map_src = "https://www.google.com/maps/embed/v1/place?q="+$("#promotion_street_address_1").val()
      +" "
      +$("#promotion_city").val()
    }
    else {
      map_src = $("#promotion_google_map_link").val()
    }
    map_src += "&key="+google_map_key+""
    $("#promotion_google_map_link").val(map_src)
    $("#googleMapModal iframe:first").attr("src", map_src)
    $("#googleMapModal").modal()
  })
  $(".image-question-title-step").on("click", function() {
    $("#modal-question-promotion").modal("show");
  });
  // set active a promotion
  $(".promtion-wrap .active-btn").on("click", function () {
    var urlActive = Routes.set_cancel_reactive_status_promotion_path($(this).parent().find(".inactive-promotion").val());
    $("#publish-modal .re-active-promotion").attr("href",urlActive)
  });

  // remove onbeforeunload event on form submit
  $(document).on("submit", "form.promotion-form", function(event){
    window.onbeforeunload = null;
  });

  // disable form submit on pressing enter
  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });
});

