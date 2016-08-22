window.Pages['HomePages'] = {
  init: function() {
    this.addToolTipsterInput();
    this.addValidationNewUser();
  },
  addToolTipsterInput: function() {
    $("#user_email, #user_first_name, #user_last_name, #user_phone_number, #user_password").tooltipster({
      trigger: 'custom',
      onlyOne: false,
      position: 'right',
      theme: 'tooltipster-shadow',
    });
  },
  addValidationNewUser: function() {
    $("#new_user").validate({
      rules: {
        "user[email]": {
          required: true,
          email: true
        },
        "user[email_confirmation]": {
          equalTo: "#user_email_sign_up"
        },
        "user[password]": {
          required: true,
          minlength: 8
        },
        "user[password_confirmation]": {
          required: true,
          equalTo: "#user_password"
        },
        "user[current_password]": {
          required: true
        },
        "user[agree_with_tos]": {
          required: true
        },
        "user[merchant_detail_attributes][business_name]": {
          required: true
        },
        "user[merchant_detail_attributes][street_address]": {
          required: true
        },
        "user[merchant_detail_attributes][city]": {
          required: true
        },
        "user[merchant_detail_attributes][state]": {
          required: true
        },
        "user[merchant_detail_attributes][zipcode]": {
          required: true,
          zipcode: true
        },
        "user[phone_number]": {
          required: true,
          phone: true
        },
        "user[first_name]": {
          required: true
        },
        "user[last_name]": {
          required: true
        },
        "user[street_address]": {
          required: true
        },
        "user[city]": {
          required: true
        },
        "user[zipcode]": {
          required: true,
          zipcode: true
        },
        "user[state]": {
          required: true
        },
        "user[ccard_last4]": {
          required: true,
          cardNumber: true
        },
        "exp": {
          required: true,
          cardExpiry: true
        },
        "cvc": {
          required: true,
          number: true,
          cardCVC: true
        }
      },
      messages: {
        "user[email]": {
          required: I18n.t("devise.sessions.new.enter_email"),
          email: I18n.t("devise.sessions.new.email_invalid")
        },
        "user[password]": {
          required: I18n.t("devise.sessions.new.enter_password"),
          minlength: I18n.t("devise.sessions.new.pass_tooshort")
        },
        "user[current_password]": {
          required: I18n.t("devise.sessions.new.enter_password")
        },
        "user[password_confirmation]": {
          required: I18n.t("devise.sessions.new.enter_password"),
          equalTo: I18n.t("devise.registrations.new.enter_same_password")
        },
        "user[email_confirmation]": {
          equalTo: I18n.t("devise.registrations.new.enter_same_email")
        },
        "user[agree_with_tos]": {
          required: I18n.t("devise.registrations.new.must_agree")
        },
        "user[merchant_detail_attributes][business_name]": {
          required: I18n.t("validate.edit_user.business_name.required")
        },
        "user[merchant_detail_attributes][street_address]": {
          required: I18n.t("validate.edit_user.street_address.required")
        },
        "user[merchant_detail_attributes][city]": {
          required: I18n.t("validate.edit_user.state.required")
        },
        "user[merchant_detail_attributes][state]": {
          required: I18n.t("validate.edit_user.state.required")
        },
        "user[phone_number]": {
          required: I18n.t("validate.edit_user.phone_number.required"),
          number: I18n.t("validate.edit_user.phone_number.number")
        },
        "user[merchant_detail_attributes][zipcode]": {
          required: I18n.t("validate.edit_user.zipcode.required"),
          number: I18n.t("validate.edit_user.phone_number.number")
        },
        "user[first_name]": {
          required: I18n.t("validate.billing.firstname.required"),
        },
        "user[last_name]": {
          required: I18n.t("validate.billing.lastname.required"),
        },
        "user[street_address]": {
          required: I18n.t("validate.edit_user.street_address.required"),
        },
        "user[city]": {
          required: I18n.t("validate.edit_user.city.required"),
        },
        "user[state]": {
          required: I18n.t("validate.edit_user.state.required"),
        },
        "user[zipcode]": {
          required: I18n.t("validate.edit_user.zipcode.required"),
          number: I18n.t("validate.edit_user.zipcode.number"),
        },
        "user[ccard_last4]": {
          required: I18n.t("validate.biling.card_number.required"),
        },
        "exp": {
          required: I18n.t("validate.biling.exp.required"),
        },
        "cvc": {
          required: I18n.t("validate.biling.cvc.required"),
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
      highlight: function(element) {
        $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
      },
      unhighlight: function(element) {
        $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
      }
    });
    if($( "#user_email_sign_up" ).length > 0){
      $( "#user_email_sign_up" ).rules( "add", {
        remote: '/auth/check_user_unique',
        messages: {
          remote: I18n.t("devise.sessions.new.email_existed")
        }
      });
    }
    if ($("#exp").length > 0)
    {
      jQuery.validator.addMethod("cardNumber", Stripe.validateCardNumber, I18n.t("validate.billing_card.card_number"));
      jQuery.validator.addMethod("cardCVC", Stripe.validateCVC, I18n.t("validate.billing_card.card_cvc"));
      jQuery.validator.addMethod("cardExpiry", function() {
      return Stripe.validateExpiry($("#exp").val().split('/')[0],
      $("#exp").val().split('/')[1])
      }, I18n.t("validate.billing_card.card_expiry"));
    }
  }
}
jQuery.ajaxSetup({
  'beforeSend': function(xhr) {
      xhr.setRequestHeader("Accept", "text/javascript");
  }
});

function update_btn_profile_tr() {
  $("#update_profile_btn").on('click', function()
  {
    if ($("#new_user").valid())
    {
      $("#new_user").submit();
    }
  });
}

function get_value_type_user (type) {
  $('#user_user_type').val(type);
  $('#new_user').submit();
}

$(document).ready(function() {
  if (window.location.hash == '#_=_') {
    window.location.hash = ''; // for older browsers, leaves a # behind
    history.pushState('', document.title, window.location.pathname); // nice and clean
    e.preventDefault(); // no page reload
  };
  $("#user_type").change(function() {
    var value = $(this).val();
    $.ajax({
      type: "GET",
      url: '#{users_path}',
      data: "user_type=" + value,
      success: function(data) {
        $("#result").html(data);
      }
    });
  });
  $("#exp").mask("99/9999");

  // Add validation from client side
  custome_placeholder();
  $("#submit_new_user").on('click', function(e) {
    if ($("#new_user").valid()) {
      if ($("input:checked").val() == 'client') {} else {
        e.preventDefault();
        $("#sec1").hide();
        $("#sec3").hide();
        $("#sec4").show();
      }
    } else {
      e.preventDefault();
    }
  });

  // Check for atleast one account_type selection
  $("#submit_merchant_registration").on("click",function(e){
      $(".checkbox-error").hide()
    if($("#new_user").valid() || !$("#new_user").valid()){
      if($(".account_type_checkbox:checked").length <= 0){
        $(".checkbox-error").show();
        e.preventDefault();
      }
    }
  });

  $(".account_type_checkbox").on('click', function(){
    if($(this).hasClass("single")){
      $(".account_type_checkbox:not('.single')").removeAttr("checked");
    }
    else{
      $(".single").removeAttr("checked")
    }
  });

  $("#to_billing_sec2").on('click', function(e) {
    if ($("#new_user").valid())
    {
      $("#billing_sec2_full_name").html($("#user_first_name").val()+" "+$("#user_last_name").val());
      $("#billing_sec2_street").html($('#user_street_address').val());
      $("#billing_sec2_state_with_code").html($('#user_city').val()+' '+$('#user_state').val()+' '+ $('#user_zipcode').val());
      $("#billing_sec2_card_num").html($("#user_ccard_last4").val());
      $("#billing_sec2_exp").html('EXP: '+ $("#exp").val());
      $("#billing_sec2_cvc").html('CVC: '+ $("#cvc").val());
      $("#select_card_review").val($('#user_card_type').val());
      $('#select_card_review').attr('disabled', '');
      $("#billing_sec2").show();
      $("#billing_sec1").hide();
    }
  });
  $("#back_sec1_add").on('click', function(e) {
      $("#billing_sec2").hide();
      $("#billing_sec1").show();
  });
  $("#back_sec1_billing").on('click', function(e) {
      $("#billing_sec2").hide();
      $("#billing_sec1").show();
  });
  $("#submit_billing_card").on('click', function(e){
    var $form = $('#new_user');
    $form.find('button').prop('disabled', true);
    var card_num = $("#user_ccard_last4").val().replace(/ /g,'');
    var cvc = $("#cvc").val();
    var month_year = $("#exp").val().split('/');
    var exp_month = month_year[0];
    var exp_year = month_year[1];
    Stripe.card.createToken({
      number: card_num,
      cvc: cvc,
      exp_month: exp_month,
      exp_year: exp_year
    }, function (status, response) {
      if (response.error) {
        var text= '<div class="alert alert-dismissable alert-danger"><button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>'+response.error.message+'</div>';
        $("#text_errors").html(text);
        $form.find('button').removeAttr("disabled");
      } else {
        // token contains id, last4, and card type
        var token = response['id'];
        var last4 = response['card'].last4;
        if ((token != '') && (last4.length == 4))
        {
          $('#user_stripe_profile_token').val(token);
          $('#user_ccard_last4').val(last4);
          $('#new_user').submit();
        }
      }
    });
  });
  $("#btn_yes").on ('click', function(e){
    window.location.href = '/auth/billing_card';
  });
  $("#btn_no").on ('click', function(e){
    window.location.href = '/auth/edit';
  });
  $("body").on('change', '.cus_check[type=checkbox]', function(e) {
    if (cus_email_check.length >= 0)
    {
      var postion = cus_email_check.indexOf(this.value);
      if ( postion == -1)
      {
        cus_email_check.push(this.value);
      }
      else
      {
        cus_email_check.splice(postion);
      }
    }
  });
  $("body").on('click', "#contact_these_cus", function(){
    if (cus_email_check.length > 0){
      $("button").prop('disabled', true);
      $.ajax({
        type: "GET",
        dataType: "json",
        url: '/promotions/get_cus_email',
        data: { cus_id_list: cus_email_check},
        async: false,
        success: function(data) {
          var string;
          for (i=0; i<data.length; i++)
          {
            string = string +""+data[i]["email"]+",";
          }
          window.location.href = "mailto:"+string+"";
          $("button").removeAttr('disabled');
        }
      });
    }
  });
  // Event submit data to login after enter password
  $(".btn-login").on("click", function () {
    $("#new_user").submit();
  });

  // Submit info of user to registration new account
  $(".button-registration-account").on('click', function () {
    $(".submit-account-user").submit();
  });
});
