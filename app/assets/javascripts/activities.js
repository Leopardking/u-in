function render_calendars_cus(input, working_day)
{

  var start_date = new Date(input['start_date']+'T00:00:00');
  var end_date = new Date(input['end_date']+'T00:00:00');
  start_date = start_date.setHours(0,0,0,0);
  end_date = end_date.setHours(0,0,0,0);
  function processing_date(date)
  {
    var day_of_week = date.getDay();
    var logic_yellow;
    var logic = (date >= start_date) && (date <= end_date);
    // date = date.setHours(0,0,0,0);
    if (logic)
    {
      var logic_more;
      for (k=0; k<working_day.length; k++)
      {
        logic_more = ((working_day[k].day_of_week == day_of_week) && (working_day[k].open == true));
        if (logic_more)
        {
          return [true, 'can_book'];
        }
      }
      return [true, ''];
    }
    else
    {
      return [true, ''];
    }
    return [true, ''];
  }
  $( "#datepicker_cus" ).datepicker({
    dayNamesMin: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
    beforeShowDay: processing_date,
    onSelect: function (date) {
      var day_now_val = new Date(date);
      var _day = day_now_val.getDate();
      var _month = day_now_val.getMonth()+1;
      var _year = day_now_val.getFullYear();
      if ((working_day[day_now_val.getDay()]['open'] == true) && (day_now_val >= start_date) && (day_now_val <= end_date))
      {
        window.location.href = Routes.view_day_activity_path(input['id'],{day: _day, month: _month, year: _year});
      }
    }
  });
}

$(document).ready(function()
{
  $("#booking_confirmation_box").hide();
  $( "body" ).on( "click", ".pre_next", function() {
    var day_now_val = new Date($("#day_now").val());
    var _day = day_now_val.getDate();
    var _month = day_now_val.getMonth()+1;
    var _year = day_now_val.getFullYear();
    var _pos = $(this).attr("id");
    var _id = $(this).data("promotion");
    $.ajax({
      type: "GET",
      url: Routes.data_day_activity_path(_id),
      data: { day: _day, month: _month, year: _year, pos: _pos},
      async: true,
      success: function(data) {
      }
    });
  });
  $( "body" ).on( "click", "#booking_on_view_day", function() {
    if ($("#form_amount_use").valid())
    {
      $("#booking_segment_id").val($("#segment_id").val());
      var _id = $(this).data("id");
      $("#msg_congration").html(I18n.t("activities.confirm_booking.msg_congratulations", {percent: $("#discount_percent").val(), date: $("#day_now_format").val(),time: $("#segment_time").val()}));
      $("#book_in_view_day").modal("hide");
      $("#table_view_day").hide();
      $("#booking_confirmation_box").show();
      $("#amount_use_v_money").val($("#amount_use").val());
    }
  });
  $( "body" ).on( "click", "#booking_no_setup", function() {
    window.location.href = Routes.auth_billing_card_path();
  });
  $( "body" ).on( "click", ".booking_day_view", function() {
    $("#segment_id").val($(this).data("segment"));
    $("#segment_time").val($(this).data("segtime"));
  });
  $( "body" ).on( "click", "#cancel_confirm_btn", function() {
    $("#table_view_day").show();
    $("#booking_confirmation_box").hide();
  });
  $( "body" ).on( "submit", "#new_booking", function() {
    $(this).find('button').prop('disabled', true);
  });
  $("#form_amount_use").validate({
      rules: {
        "amount_use": {
          range: [0,  $("#virtual_money").val()],
          number: true,
          less: '#discount_price'
        }
      },
      onfocusout: function(element) {
      return $(element).valid();
      },
      highlight: function(element) {
        $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
      },
      unhighlight: function(element) {
        $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
      }
    });
  $( "body" ).on( "change, keyup", "#amount_use", function() {
    if ($("#form_amount_use").valid())
    {
      var sub= $("#discount_price").val() - $(this).val();
      sub = sub.toFixed(2);
      $("#will_charge").html(I18n.t("activities.confirm_book.charge_msg", {money: sub}));
    }
  });
  $( "body" ).on( "click", "#booking_on_day", function() {
    // $("#form_amount_use")[0].reset();
    $("#will_charge").html(I18n.t("activities.confirm_book.charge_msg", {money: $("#discount_price").val() - $("#amount_use").val()}));
    $("#amount_use").closest('.form-group').removeClass('has-success').removeClass('has-error');
    $(".error").remove();
  });
  $( "body" ).on( "submit", "#form_amount_use", function(e) {
     e.preventDefault();
     return false;
  });
});


