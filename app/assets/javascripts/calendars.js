window.Pages['CalendarPage'] = {
  init: function() {
    this.numberBooking = 0; // set default value for number booking

    this.renderingEvent = false; // this property is for checking whether calendar should render event or not.
    this.initDataCalendar();
    this.getInfoNumberBookingFree();
    this.getInfoBooking();
    this.addTooltipsterBookingForm();
    this.validationForInfoBooking();
    this.turnOffModal();
    this.showNotificationBooking();
    this.submitFormBooking();
    this.sameAsCompanyAdress();
    this.showModalInputPaymentBooking();
    this.chargePaymentToBookingMerchant();
    this.showInactivePromotionInMonth();
  },
  initDataCalendar: function() {
    var _this = this;
    var promotionId = _this.promotionId;
    var promotionType = getUrlParameter("inactive");
    var id = _this.id;
    $("#calendar,#calendar_at_promotion").fullCalendar({
      weekMode: 'variable',  //Hide previous months extra dates
      height: 650,
      eventLimit: 4,
      header: {
        left: 'prev,next today myCustomButton',
        center: 'title',
        right: 'month,agendaWeek,agendaDay'
      },
      editable: false, // Disable the event inline functionality
      defaultView: _this.agendaView,
      defaultDate: _this.defaultDate,
      events: function(start, end, timezone, callback) {
        var events = [];
        $.ajax({
          url: event_url,
          data: {
            start_date: start.format(),
            end_date: end.format(),
            promotion_id: promotionId,
            inactive_promotion: promotionType,
            id: id
          },
          success: function(doc) {
            var title = "";
            $(doc).each(function() {
              _event = this;
              switch(_event.event_status) {
                case 'sold_out':
                  title = _event.sold_out
                  break;
                case 'regular_available':
                  title = _event.booking_regular_price;
                  break;
                default:
                  title = _event.title;
              };
              events.push({
                discount_percent: $(this).attr("discount_percent"),
                name: $(this).attr("name"),
                title: title,
                start: $(this).attr('start'),
                end: $(this).attr('end'),
                id: $(this).attr('id'),
                blackout_id: $(this).attr('blackout_id'),
                bookings: $(this).attr('bookings'),
                date_of_lastest_booking: $(this).attr('date_of_lastest_booking'),
                number_bookings_in_current_period: $(this).attr('number_bookings_in_current_period'),
                total_bookings: $(this).attr('total_bookings'),
                blackout: $(this).attr('blackout'),
                custom_blackout: $(this).attr('custom_blackout'),
                allDay: $(this).attr('allDay'),
                promotion_price: $(this).attr('promotion_price'),
                paid_price: $(this).attr("paid_price"),
                booking_regular_price: $(this).attr("booking_regular_price"),
                booking_promotion_avaiable: $(this).attr("booking_promotion_avaiable"),
                booking_without_promotion: $(this).attr("booking_without_promotion"),
                booking_without_promotion_total: $(this).attr("booking_without_promotion_total"),
                cancel_status: $(this).attr("cancel_status"),
                booked_promotion: $(this).attr("booked_promotion"),
                event_status: _event.event_status
              });
            });
            _this.renderingEvent = true; // Create a sign to tell calendar should start rendering event.
            callback(events);
            _this.renderingEvent = false;
            // Create a sign to tell calendar should stop rendering event any more after all events were rendered.
          }
        });
      },
      loading: function (bool) {
        if (bool)
          $("#calendar-loader").css({"visibility": "visible"})
        else
          $("#calendar-loader").css({"visibility": "hidden"})
      },
      // To load normal/segmented events based on the views
      viewRender: function( view, element ){
        agendaView = view.name;
        if(view.name == "agendaDay" || view.name == "agendaWeek"){
          event_url = Routes.get_segmented_events_calendars_path()
          $("#inactive_promotion").addClass('hide');
        }else{
          event_url = Routes.get_events_calendars_path()
        }
        $("#calendar").fullCalendar( 'refetchEvents' )
        window.Pages['CalendarPage'].showHideInactivePromotion(promotionType);
      },
      eventAfterAllRender: function(view){
        // if(view.name == "month" || view.name == "agendaWeek"){
        if(view.name == "month"){
          // To remove rendering blackout slots if the view is month
          $(".blackout_event").remove();
        }
      },
      dayClick: function(date, allDay, jsEvent, view) {
        if (!promotionType){
          $('#calendar').fullCalendar('changeView', 'agendaDay')
          $('#calendar').fullCalendar('gotoDate',date.format());
        }
      },
      eventClick: function(calEvent, jsEvent, view) {
        // only show when view data in month with active promotion
        if (!promotionType){
          var timeNow = Date.now();
          var timeLastest = Date.parse(calEvent.date_of_lastest_booking);
          if (timeLastest >= timeNow){
            $("#optionsPopUp #edit-promotion-current").attr("disabled", true);
          }

          if(Date.parse(calEvent.start._i) <= timeNow){
            $("#optionsPopUp #blackout-btn").attr("disabled",true);
          }
          else if(calEvent.number_bookings_in_current_period > 0){
            $("#optionsPopUp #blackout-btn").attr("disabled",true);
          }
          else {
            $("#optionsPopUp #blackout-btn").attr("disabled", false);
          }

          if((view.name == "agendaWeek" || view.name == "agendaDay")){
            if(!$(this).hasClass("blackout_event")){
              $("#optionsPopUp #edit_promo").attr("href", "/promotions/"+calEvent.id+"/edit")
              $("#optionsPopUp div.modal-body h2").text(calEvent.title.split("Off ")[0]+ " Off")
              $("#optionsPopUp div.modal-body p.head").text(calEvent.title.split("Off ")[1])
              $("#optionsPopUp #cal_date").val(calEvent.start._i)
              $("#optionsPopUp #slot_start").val(calEvent.start._i)
              $("#optionsPopUp #slot_end").val(calEvent.end._i)
              $("#optionsPopUp #promotion_now_id").val(calEvent.id)
              $("#optionsPopUp #discount_percent_active").val(calEvent.discount_percent);
              $("#optionsPopUp #event_status").val(calEvent.event_status);
              $("#optionsPopUp #promotion_name_active").val(calEvent.name)
              $("#optionsPopUp #promotion_price_current").val(calEvent.promotion_price);
              $("#optionsPopUp #paid_price_current").val(calEvent.paid_price);
              switch(calEvent.event_status) {
                case 'promotion_available':
                  $("#optionsPopUp .total-slot-booking").html(calEvent.total_bookings);
                  $("#optionsPopUp .number-slot-booking").html(calEvent.bookings);
                  numberBooking = calEvent.booking_promotion_avaiable;
                  break;
                case 'sold_out':
                  $("#optionsPopUp .total-slot-booking").html(calEvent.booking_without_promotion_total);
                  $("#optionsPopUp .number-slot-booking").html(calEvent.booking_without_promotion_total);
                  break;
                default:
                  $("#optionsPopUp .total-slot-booking").html(calEvent.booking_without_promotion_total);
                  $("#optionsPopUp .number-slot-booking").html(calEvent.booking_without_promotion);
                  numberBooking = calEvent.booking_promotion_avaiable;
                  // numberBooking = calEvent.select_constant_booking
              };
              if (calEvent.event_status == 'sold_out' || Date.parse(calEvent.start._i) < timeNow) {
                $("#optionsPopUp .button-booking-event").attr("disabled", true)
                $("#book_promo").css("cursor","default");
              } else {
                $("#optionsPopUp .button-booking-event").attr("disabled", false)
              }

              // TODO: must add the link to book action
              // $("#optionsPopUp #book_promo").attr("href", "/promotions/"+calEvent.id+"/book")
              $("#optionsPopUp").modal()
            }else{
              if(calEvent.custom_blackout)
              {
                $.ajax({
                  url: Routes.get_blackout_details_promotions_path(),
                  data: {
                    blackout_id: calEvent.blackout_id
                  }
                })
              }
              else{
                alert("You can't cancel this blackout")
              }
            }
          }else{
            // check user has click from promotion to calendar
            if($("#calendar_at_promotion").is(":visible")){
              window.location.href = Routes.calendars_path({date: calEvent.start.format("YYYY-MM-DD")})
            }
            $('#calendar').fullCalendar('changeView', 'agendaDay')
            $('#calendar').fullCalendar('gotoDate',calEvent.start.format("YYYY-MM-DD"));
          }
        } //end check if promotioType
      },
      eventRender: function(event, element, view) {
        // There is an issue: events of previous view still be rendered without calling callback. Don't know why!!!
        // The temporary solution is only render event when "_this.renderingEvent" is true. But we should find the root cause why old ovents still be rendered
        if (!_this.renderingEvent) return;
        // check view to show active or inactive promotion
        if (promotionType) {
          $(element).css({"border-color": "#3C3B3B","border-width":"1px",
         "border-style":"solid","margin-bottom":"2px", "min-height":"70px","background-color": "#3C3B3B"});
          $(element).find(".fc-content").css({"background-color": "#3C3B3B", "color": "#E6E3E3"});
        }else{
          if (view.type === 'month'){
            var date = event.start.format('YYYY-MM-DD');
            $('.fc-bg .fc-day[data-date='+ date +']').css('background', '#99CC66');
          }
          if(event.blackout){
            // If the event is blackout event, Add the corresponding CSS
            $(element).addClass("blackout_event")
          }else{
            var booking_details = "";

            switch(event.event_status) {
              case 'sold_out':
                generalSoldoutEvent(element, event, view);
                break;
              case 'regular_available':
                booking_details = "<div class='booking-event'>"+ event.booking_without_promotion + " of " + event.booking_without_promotion_total + "<br><span>" + I18n.t('booked') + "</span></div>"
                element.append(booking_details);
                $(element).find(".booking-event").css({"background-color": "#FF3333", "opacity" : "0.5"});
                break;
              case 'promotion_available':
                booking_details = "<div class='booking-event'>" + event.bookings + " of " + event.total_bookings + "<br><span>" + I18n.t('booked') + "</span></div>";
                element.append(booking_details);
                break;
            };
          }
        }
      }
    });
    $("#blackout-btn").on("click", function(){
      id = $("#optionsPopUp #edit_promo").attr("href").split("/")[2]
      $.ajax({
        url: "/calendars/get_promotion_for_blackout",
        data: {promotion_id: id, selected_date: $("#optionsPopUp #cal_date").val()}
      })
    });
    window.Pages['CalendarPage'].showHideInactivePromotion(promotionType);
  },
  getInfoNumberBookingFree: function(){
    $("#book_promo").on("click", function() {
      if($("#numbers_booked").find(":selected").val() != 1){
        $("#numbers_booked").val([]); //remove selected from select option
      }
      var timeNow = Date.now();
      var time_charge = $("#time_charge").val();
      var timeCharge = new Date(time_charge).getTime();
      var book_free = $("#book_free").val();
      if(timeCharge > timeNow){
        $(".information-number-booking-free").html(I18n.t("bookings.booking_event_popup_modal.unlimited_booking"));
      }else{
        $(".information-number-booking-free").html(I18n.t("bookings.booking_event_popup_modal.number_booking_free",{numbers: book_free}));
      };
    });
    $("#new_billing_detail").bind('ajax:complete', function() {
      $(".information-number-booking-free").html(I18n.t("bookings.booking_event_popup_modal.unlimited_booking"));
    });
  },
  getInfoBooking: function() {
    $("#book_promo").on("click", function() {
      // check button has disabled
      if($("#optionsPopUp .button-booking-event").attr("disabled")) {
        return;
      };
      $("#BookingPromotion .error-message-booking").css("display","none")
      $("#number_booking_promotion").html(numberBooking)
      $(".select-wrapper > span").html($("option:first-child").val());
      $("#BookingPromotion").modal("show");
      $("#optionsPopUp").modal("hide");
      $("#booking_book_date").val($("#cal_date").val());
      $("#booking_start_time").val($("#slot_start").val());
      $("#booking_end_time").val($("#slot_end").val());
      var valueDiscount = $("#discount_percent_active").val();
      var eventStatus = $("#event_status").val();
      var booleanValue = (valueDiscount > 0 && eventStatus == 'promotion_available') ? "true" : "false";
      $("span.discount-of-promotion-active").html(valueDiscount+"%");
      $("span.name-of-promotion-active").html($("#promotion_name_active").val());
      $("#booking_promotion_id").val($("#promotion_now_id").val());
      $("#booking_check_discount").val(booleanValue);
      $("#booking_promotion_price").val($("#promotion_price_current").val());
      $("#booking_paid_price").val($("#paid_price_current").val());
    });
  },
  showHideInactivePromotion: function(promotionType){
    // check promotion type to show,hide button inactive promotion and active promotion
    if (!promotionType) {
      $("#calendar .fc-agendaWeek-button,#calendar .fc-agendaDay-button").removeClass('hide');
      $("#inactive_promotion").removeClass('hide');
    }else{
      $("#inactive_promotion").addClass('hide');
      $("#show_active_promotion").removeClass('hide');
      $("#calendar .fc-agendaWeek-button,#calendar .fc-agendaDay-button").addClass('hide');
    }
  },
  validationForInfoBooking: function() {
    $("#new_booking").validate({
      rules: {
        "booking[first_name]": {
          required: true,
        },
        "booking[last_name]": {
          required: true,
        },
        "booking[email]": {
          required: true,
          email: true
        },
        "booking[phone]": {
          phone: true
        }
      },
      messages: {
        "booking[first_name]": {
          required: I18n.t("validate.bookings.firstname.required")
        },
        "booking[last_name]": {
          required: I18n.t("validate.bookings.lastname.required")
        },
        "booking[email]": {
          required: I18n.t("validate.bookings.email.required"),
          email: I18n.t("validate.bookings.email.invalid")
        },
        "booking[phone]": {
          number: I18n.t("validate.bookings.phone.number")
        }
      },
      errorPlacement: function (error, element) {
        $(element).tooltipster('update', $(error).text());
        $(element).tooltipster('show');
      },
      success: function (label, element) {
        $(element).tooltipster('hide');
      },
      onfocusout: false,
      highlight: function (element) {
        $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
      },
      unhighlight: function (element) {
        $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
      }
    });
  },
  addTooltipsterBookingForm: function() {
    $("#booking_first_name, #booking_last_name").tooltipster({
      trigger: 'custom',
      onlyOne: false,
      position: 'top',
      theme: 'tooltipster-shadow'
    });
    $("#booking_email, #booking_phone").tooltipster({
      trigger: 'custom',
      onlyOne: false,
      position: 'bottom',
      theme: 'tooltipster-shadow'
    });
  },
  turnOffModal: function() {
    $("#cancle-booking-promotion").on('click', function() {
      $("#booking_first_name, #booking_last_name, #booking_email, #booking_phone").tooltipster('disable');
      $("#BookingPromotion").modal("hide");
      return false;
    });
    $("#booking-promotion-active").on("click", function(){
      $("#booking_first_name, #booking_last_name, #booking_email, #booking_phone").tooltipster('enable');
    });
    $("#button-cancel-edit-payment").on('click', function() {
      $("#InputInFoCardBooking").modal("hide");
      return false;
    });
  },
  sameAsCompanyAdress: function() {
    $("#billing_detail_same_as_company_address").on("change", function(){
      if ($(this).is(':checked')) {
        $.ajax({
          url: Routes.business_address_user_path($("#user_id").val()),
          success: function(data){
            if (data.billing_detail != null) {
              $(".may_disable").siblings(".error").remove();
              $("#billing_detail_first_name").val(data.billing_detail.first_name);
              $("#billing_detail_last_name").val(data.billing_detail.last_name);
              $("#billing_detail_street_address_2").val(data.billing_detail.street_address_2);
              $(".may_disable").parent().removeClass("has-error");
              $("#billing_detail_street_address").val(data.billing_detail.street_address);
              $("#billing_detail_city").val(data.billing_detail.city);
              $("#billing_detail_state").val(data.billing_detail.state);
              $("#billing_detail_zipcode").val(data.billing_detail.zipcode);
              $("#billing_detail_phone").val(data.billing_detail.phone);
              $("#billing_detail_email").val(data.billing_detail.email);
              $(".may_disable").attr('readonly',true);
            }
          }
        })
      } else {
       $(".may_disable").attr('readonly', false);
      }
    });
    if ($("#billing_detail_same_as_company_address").is(':checked')) {
      $(".may_disable").attr('readonly',true);
    }
  },
  showModalInputPaymentBooking: function () {
    $(".button-booking-segement").on("click", function() {
      if ($("#new_booking").valid()) {
        $("#InputInFoCardBooking").modal("show");
      }
    });
  },
  chargePaymentToBookingMerchant: function() {
    $(".submit-form-info-payment").on("click", function() {
      var numberCard = $("#billing_detail_ccard_last4").val();
      var cvcCard = $("#billing_detail_security_code").val();
      var expMonth = $("#billing_detail_exp_month").val();
      var expYear = $("#billing_detail_exp_year").val();
      window.Pages['StripeProcess'].createCardToken(numberCard, cvcCard, expMonth, expYear, window.Pages['CalendarPage'].stripeResponse);
    });
  },
  stripeResponse: function(status, response) {
    if (response.error) {
      $(".noti-stripe-errors p.stripe-errors").text(response.error.message);
      $(".noti-stripe-errors p.stripe-errors").removeClass("display-none-element");
      $(".noti-stripe-errors p.stripe-errors").addClass("display-show-element");
    } else {
      $(".noti-stripe-errors p.stripe-errors").text("");
      $(".noti-stripe-errors p.stripe-errors").addClass("display-none-element");
      var stripeToken = response.id;
      $("#stripe_token").val(stripeToken);
      $("form.billing-detail-form").submit();
    }
  },
  showInactivePromotionInMonth: function(){
    $("#inactive_promotion").on("click",function(){
      window.location.href = window.location.href + "?inactive=true"
      $("#inactive_promotion").addClass('hide');
      $("#show_active_promotion").removeClass('hide');
      $("#calendar .fc-agendaWeek-button,#calendar .fc-agendaDay-button").addClass('hide');
    });
    $("#show_active_promotion").on("click",function(){
      var href = removeParam(window.location.href);
      window.location.href = href;
      $("#inactive_promotion").removeClass('hide');
      $("#show_active_promotion").addClass('hide');
      $("#calendar .fc-agendaWeek-button,#calendar .fc-agendaDay-button").removeClass('hide');
    });
  },
  showNotificationBooking: function() {
    $("#booking-promotion-active").click(function() {
      var getNumerBooked = $("#numbers_booked").val();
      var getNumberBookingFree = parseInt($("#number-free-book").html());
      if (getNumerBooked > getNumberBookingFree) {
        if ($("#new_booking").valid()) {
          $("#booking-fee-warning").html(I18n.translate("bookings.booking_confirm_popup_modal.title_popup", {value:getNumberBookingFree}));
          if (getNumberBookingFree != 0)
            $("#booking-confirm-modal").modal("show");
          else
            $("#new_booking").submit();
        }
      } else{
        $("#new_booking").submit();
      }
    });
  },
  submitFormBooking: function() {
    $("#submit-booking-form").click( function(){
      $("#new_booking").submit();
      $("#booking-confirm-modal").modal("hide");
    })
  }
}
var event_url = ""
var timee = new Date();

function generalSoldoutEvent(element, event, view){
  var soldoutDate = moment(event.start).format('YYYY-MM-DD');
  var maximumBookings = view.type === 'month' ? (event.booking_without_promotion_total + event.total_bookings) : event.booking_without_promotion_total
  booking_details =  "<div class='booking-event'>" + maximumBookings + " of " + maximumBookings + "<br><span>" + I18n.t('booked') + "</span></div>"
  element.append(booking_details);
  $(element).find(".booking-event").css({"background-color": "#696a6a"});
  $(element).css({"background-color": "#a4a4a4"});
  $(element).css({"border-color": "#a4a4a4","border-width":"1px",
 "border-style":"solid"});
  $(element).find(".fc-content").css({"background-color": "#c8c8c8"});
  $('.fc-content-skeleton').find("[data-date='"+soldoutDate+"']").css({"background-color": "#a4a4a4"});
}

function formatAMPM(date) {
  var hours = date.getHours();
  var minutes = date.getMinutes();
  var ampm = hours >= 12 ? 'pm' : 'am';
  hours = hours % 12;
  hours = hours ? hours : 12; // the hour '0' should be '12'
  minutes = minutes < 10 ? '0'+minutes : minutes;
  var strTime = '0' + hours + ':' + minutes + ' ' + ampm;
  return strTime;
}
