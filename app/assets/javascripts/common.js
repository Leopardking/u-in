window.Pages['CommonJs'] = {
  init: function() {
  },
  uploadImageAfterChange: function(selectElem, formSubmit) {
    var _this = this;
    $(selectElem).on('change', function() {
      var fileExtension = JSConstant.TYPE_IMAGE;
      if ($.inArray($(this).val().split('.').pop().toLowerCase(), fileExtension) == -1) {
        // Show modal error type image
        $("#error-message-image-type").modal("show");
      } else {
        if (this.files && this.files[0]) {
          var fileImage = this.files[0],
              sizeMax = fileImage.size/1024/1000,
              reader = new FileReader();
          reader.onload = function(e) {
            if (sizeMax <= JSConstant.MAX_SIZE_IMAGE) {
              $(formSubmit).submit();
              // Call LOADING_URL
              _this.showLoading(I18n.t('js.loading.uploadding'));
            } else {
              // Show modal error size image
              $("#error-message-image-size").modal("show");
            }
          }
          reader.readAsDataURL(fileImage);
        }
      }
    });
  },
  showLoading: function(strLoading) {
    $.blockUI({ message: "<h1><img class='img-upload' src='"+JSConstant.LOADING_URL+"'><span class='message-upload'>"+strLoading+"</span></h1>"});
  }
}
var array_flag = new Array();
$(document).ready(function(){

  $('body').on('click', '#schedules-page .btn.btn-danger', function(){
    $('#delete_schedules_btn').attr('href', $(this).attr('data-path'));
    $("#delete_schedules").modal('toggle');
  });

  $('body').on('keyup', '#hr ', function(){
    for(i = 0; i < 7; i++ ){
      $("#hr_" + i).val($("#hr").val());
      var sum = parseInt($("#hr_"+i).val() )*60 + parseInt($("#min_"+i).val() );
      $("#working_schedule_working_days_attributes_"+i+"_segment").val(sum);
    }
  });

  $('body').on('keyup', '#min ', function(){
    for(i = 0; i < 7; i++ ){
      $("#min_" + i).val($("#min").val());
    }
  });

  $('body').on('change', '#segment_duration', function(){
    for(i = 0; i < 7; i++ ){
      $("#working_schedule_working_days_attributes_" + i + "_segment_duration").val($("#segment_duration").val());
    }
  });
  /**
   * Validate Contact Form
   */
  $('#contact-form').validate({
    rules: {
      'contact[email]': {
        required: true,
        email: true
      },
      'contact[message]': {
        required: true
      }
    },
    message: {
      'contact[email]': {
        required: I18n.t('validate.contact_form.email.required'),
        email: I18n.t('validate.contact_form.email.invalid')
      },
      'contact[message]': {
        required: I18n.t('validate.contact_form.message.required')
      }
    },
    onfocusout: false,
    highlight: function (element) {
      $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
    },
    unhighlight: function (element) {
      $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
    }
  });


  /**
   * Validate Edit Merchant Profile Form
   */
  $('#edit_merchant_profile').validate({
    rules: {
      'user[merchant_detail_attributes][business_name]': {
        required: true
      },
      'user[merchant_detail_attributes][street_address]': {
        required: true
      },
      'user[merchant_detail_attributes][city]': {
        required: true
      },
      'user[merchant_detail_attributes][state]': {
        required: true
      },
      'user[merchant_detail_attributes][zipcode]': {
        required: true
      },
      'user[merchant_detail_attributes][phone_number]': {
        required: true
      },
      'user[email]': {
        required: true,
        email: true
      }
    },
    message: {
      'user[merchant_detail_attributes][business_name]': {
        required: I18n.t('validate.edit_user.business_name.required')
      },
      'user[merchant_detail_attributes][street_address]': {
        required: I18n.t('validate.edit_user.street_address.required')
      },
      'user[merchant_detail_attributes][city]': {
        required: I18n.t('validate.edit_user.city.required')
      },
      'user[merchant_detail_attributes][state]': {
        required: I18n.t('validate.edit_user.state.required')
      },
      'user[merchant_detail_attributes][zipcode]': {
        required: I18n.t('validate.edit_user.zipcode.required')
      },
      'user[merchant_detail_attributes][phone_number]': {
        required: I18n.t('validate.edit_user.phone_number.required')
      },
      'user[email]': {
        required: I18n.t('validate.edit_user.email.required'),
        email: I18n.t('validate.edit_user.email.invalid')
      }
    },
    onfocusout: false,
    highlight: function (element) {
      $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
    },
    unhighlight: function (element) {
      $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
    }
  });


  /**
   * Validate Edit Client Profile Form
   */
  $('#edit_client_profile').validate({
    rules: {
      'user[billing_detail][street_address]': {
        required: true
      },
      'user[billing_detail][city]': {
        required: true
      },
      'user[billing_detail][state]': {
        required: true
      },
      'user[billing_detail][zipcode]': {
        required: true
      },
      'user[billing_detail][first_name]': {
        required: true
      },
      'user[billing_detail][last_name]': {
        required: true
      },
      'user[email]': {
        required: true,
        email: true
      },
      'user[email_confirmation]': {
        equalTo: "#user_email"
      }
    },
    message: {
      'user[billing_detail][street_address]': {
        required: I18n.t('validate.edit_user.street_address.required')
      },
      'user[billing_detail][city]': {
        required: I18n.t('validate.edit_user.city.required')
      },
      'user[billing_detail][state]': {
        required: I18n.t('validate.edit_user.state.required')
      },
      'user[billing_detail][zipcode]': {
        required: I18n.t('validate.edit_user.zipcode.required')
      },
      'user[billing_detail][first_name]': {
        required: I18n.t('validate.edit_user.first_name.required')
      },
      'user[billing_detail][last_name]': {
        required: I18n.t('validate.edit_user.last_name.required')
      },
      'user[email]': {
        required: I18n.t('validate.edit_user.email.required'),
        email: I18n.t('validate.edit_user.email.invalid')
      },
      'user[email_confirmation]': {
        equalTo: I18n.t('validate.edit_user.email_confirmation.equalto')
      }
    },
    onfocusout: false,
    highlight: function (element) {
      $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
    },
    unhighlight: function (element) {
      $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
    }
  });


  /**
   * Validate Change Password Form
   */
  $('#change-password-form').validate({
    rules: {
      'user[password]': {
        required: true
      },
      'user[password_confirmation]': {
        required: true,
        equalTo: '#user_password'
      },
      'user[current_password]': {
        required: true
      }
    },
    message: {
      'user[password]': {
        required: I18n.t('validate.change_password_form.password.required')
      },
      'user[password_confirmation]': {
        required: I18n.t('validate.change_password_form.password_confirmation.required'),
        equalto: I18n.t('validate.change_password_form.password_confirmation.equalto')
      },
      'user[current_password]': {
        required: I18n.t('validate.change_password_form.current_password.required')
      }
    },
    onfocusout: false,
    highlight: function (element) {
      $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
    },
    unhighlight: function (element) {
      $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
    }
  });


  // /**
  //  * Add View more/less on Faqs
  //  */
  //  $('.faq span.content').shorten({
  //   'showChars' : 300,
  //   'moreText'  : I18n.t("common.view_more"),
  //   'lessText'  : I18n.t("common.view_less")
  // });


  /**
   * Date Picker for all input fields that having attribute: data-type="date"
   * Note: pick date only
   */
  $('.input-group.date').datetimepicker({
    pickTime: false
  });


  /**
   * Time Picker for all input fields that having attribute: data-type="time"
   * Note: pick time only
   */
  $('input[data-type="time"]').datetimepicker({
    pickDate: false
  });

  $("#new-schedule-form").validate({
    rules: {
      "working_schedule[schedule_name]": {
        required: true
      },
      "working_schedule[start_date]": {
        required: true,
        day_in_past: true,
        dateBefore: '#working_schedule_end_date'
      },
      "working_schedule[end_date]": {
        required: true,
        dateAfter: '#working_schedule_start_date'
      }
    },
    messages: {
      "working_schedule[schedule_name]": {
        required: I18n.t("validate.working_schedule.name")
      },
      "working_schedule[start_date]": {
        required: I18n.t("promotions.validation.start_date")
      },
      "working_schedule[end_date]": {
        required: I18n.t("promotions.validation.end_date")
      }
    },
    errorPlacement: function(error, element)
    {
      if (element.is(".row"+$(element).data("index")))
      {
        $("#_error_schedule_row_"+$(element).data("index")).html(error);
      }
      else
      {
        if($(element).data("type") == 'start')
        {
          error.appendTo($('#err_start'));
        }
        else
        {
          if ($(element).data("type") == 'end')
          {
            error.appendTo($('#err_end'));
          }
          else
          {
            error.appendTo(element.parent());
          }
        }
      }
    },
    onfocusout: true,
    onkeyup: false,
    ignore: '',
    highlight: function (element)
    {
      if ($(element).hasClass( "segment"+$(element).data("index")))
      {
        $(element).siblings('.form-group').removeClass('has-success').addClass('has-error').addClass('wtf');
        array_flag.push($(element).data("index"));
        array_flag.push($(element).data("index"));
      }
      else
      {
        $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
      }
    },
    unhighlight: function (element)
    {
      if (!$(element).closest('.form-group').hasClass("wtf"))
        $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
      else
      {
        var check = check_hr_min(element,array_flag);
        if (check)
        {
          var value = array_flag[i];
          array_flag.splice(array_flag.indexOf[value],1);
        }
        else
        {
          $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
        }
      }
    }
  });
  $( "body" ).on( "change, keyup", ".hr,.min", function() {
    var e = $(this);
    var index = e.data("index");
    var sum = parseInt($("#hr_"+index).val() )*60 + parseInt($("#min_"+index).val() );
    $("#working_schedule_working_days_attributes_"+index+"_segment").val(sum);
  });

  $('.open-checkbox').change(function(){
    var index = $(this).data('index');
    var checked = $(this).is(':checked');
    var reference = $(this).data('reference');
    $(reference).each(function() {
      var e = $(this);
      if (checked)
          {
              e.rules('add',
              {
                required: true,
                messages:
                {
                  required: I18n.t("promotions.validation.msg_err_for_row")
                }
              });
              // adding validation for the #of spots available field
              // if (e.is("#working_schedule_working_days_attributes_" + index + "_available_spots"))
              // {
              //   e.rules('add',
              //   {
              //     number: true
              //   });
              // }
              if (e.is(".segment" + index))
              {
                e.rules('add',
                {
                  time_less: '.segment_duration' + index
                });
              }
              if (e.is("#min_" + index))
              {
                e.rules('add',
                {
                  range: [0, 60]
                });
              }
              if (e.is("#hr_" + index))
              {
                e.rules('add',
                {
                  range: [0, 24]
                });
              }
          }
      else{
        e.rules( "remove" );
      }
    });
  })

  $('.open-checkbox').trigger('change');

  $("body").on('submit', '#new-schedule-form', function(e) {
      $("img#ajax-loader").removeClass("temp_hide")  //Show a ajax loader while submitting the form
      var a_day_check = new Array();
      $(".open").each(function() {
        var e = $(this);
        if (e[0].checked == true)
        {
          a_day_check.push(e.data("day"));
        }
      });
    $.ajax({
      type: "POST",
      url: Routes.check_conflict_working_schedules_path(),
      data: { id: $("#working_schedule_id").val(), start_date: $("#working_schedule_start_date").val(), end_date: $("#working_schedule_end_date").val(), a_day_check: a_day_check, repeat_sche: $("#working_schedule_repeat")[0].checked },
      async: false,
      success: function(data) {
        if (data == true)
        {
          var text= '<div class="col-md-12"><div class="alert alert-dismissable alert-danger"><button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>'+I18n.t("schedules.form.msg_conflict")+'</div></div>';
          $("#error_crud_here").html(text);
          e.preventDefault();
          return false;
        }
      }
    });
  });
  $("body").on('click', '#working_schedule_repeat', function(e) {
    if ($("#working_schedule_id").val() == "")
    {
      if ($("#working_schedule_repeat")[0].checked == true)
      {
        $("#start_end_time").addClass('temp_hide');
        $("#working_schedule_start_date").val(moment(new Date).format('MM/DD/YYYY'));
        $("#working_schedule_end_date").val(moment(new Date).format('MM/DD/YYYY'));
      }
      else
      {
        $("#working_schedule_start_date").attr('disabled',false);
        $("#working_schedule_start_date").val("");
        $("#working_schedule_end_date").val("");
        $("#working_schedule_end_date").attr('disabled',false);
        $("#start_end_time").removeClass('temp_hide');
      }
    }
    else
    {
      if ($("#working_schedule_repeat")[0].checked == true)
      {
        $("#start_end_time").addClass('temp_hide');
        $("#working_schedule_end_date").val(moment(new Date).format('MM/DD/YYYY'));
      }
      else
      {
        $("#start_end_time").removeClass('temp_hide');
        $("#working_schedule_end_date").val("");

      }
    }
  });
});

function check_hr_min(element, array_flag) {
  for (i= 0; i< array_flag.length; i++)
  {
    if ($(element).is("#hr_"+array_flag[i]) || $(element).is("#min_"+array_flag[i]))
    {
      return true;
    }
  }
}
/**
 * Clone break time in creating new schedule
 */
function cloneBreak(self){
  var row_el = $(self).closest(".form-group").find(".row.multi");
  var clone = row_el.clone();

  // Reset value
  $(clone).find('input').removeAttr('value');
  $(clone).find('select').find('option:selected').removeAttr("selected");

  clone = clone.html();
  var new_id = new Date().getTime();
  var new_el = clone.replace(/\[(\d+)\]/g, "[" + new_id + "]");
  var html = "<div class=\"row pd-15 multi\">" + new_el + "</div>";
  var parent = row_el.parent();
  parent.append(html);

  // Trigger Time Picker event
  $('input[data-type="time"]').datetimepicker({
    pickDate: false
  });

}

/**
 * Remove break
 */
function removeBreak(self){
  var parent = $(self).parent();
  if ($(self).attr("data-id") != null && $(self).attr("data-id") != "undefined"){
    var id = $(self).data("id");
    var remove_break_times = $("#remove_break_times").val();
    remove_break_times += (remove_break_times != "") ? "," + id : id;

    $("#remove_break_times").val(remove_break_times);
  }
  parent.remove();
}

/*Remove params from url*/
function removeParam(uri) {
   return uri.substring(0, uri.indexOf('?'));
}

/*Get value from url*/
function getUrlParameter(sParam) {
  var sPageURL = decodeURIComponent(window.location.search.substring(1)),sURLVariables = sPageURL.split('&'),sParameterName,i;
  for (i = 0; i < sURLVariables.length; i++) {
    sParameterName = sURLVariables[i].split('=');
    if (sParameterName[0] === sParam) {
        return sParameterName[1] === undefined ? true : sParameterName[1];
    }
  }
};

/**
 * Update schedule status
 */
function updateScheduleStatus(self){
  var schedule_id = $(self).data('id');
  var status = $(self).data('status') == true ? false : true;
  $.ajax({
    type: "POST",
    url: "schedules/"+(schedule_id)+"/update_status",
    data: {
      id: schedule_id,
      active: status
    },
    dataType: 'json',
    success: function(response){
      if (response.flag == null){
        var text= '<div class="col-md-12"><div class="alert alert-dismissable alert-danger"><button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>'+I18n.t("schedules.form.no_days")+'</div></div>';
        $("#error_crud_here").html(text);
      }
      else if(response.promotions == true){
        var text= '<div class="col-md-12"><div class="alert alert-dismissable alert-danger"><button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>'+I18n.t("schedules.form.has_promotions")+'</div></div>';
        $("#error_crud_here").html(text);
      }
      else if (response.flag == false){
        // Assign status to the DOM
        $(self).data('status', status);

        // Change the status
        if ($(self).hasClass('active')){
          $(self).removeClass('active');
        } else {
          $(self).addClass('active');
        }
      }
      else
      {
        var text= '<div class="col-md-12"><div class="alert alert-dismissable alert-danger"><button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>'+I18n.t("schedules.form.msg_conflict")+'</div></div>';
        $("#error_crud_here").html(text);
      }
    }
  });
}
