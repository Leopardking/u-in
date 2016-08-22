window.Pages['EditProfilePage'] = {
  init: function() {
    this.showFormEditPayment();
    this.getSameCompanyAddress();
    this.changeTypeInput();
    this.validateForEditPayment();
    this.addValidateImageAvatar();
    this.addValidationEditUser();
    this.submitFormEditUser();
    this.uploadPicProfile();
  },
  showFormEditPayment: function() {
    $(".button-edit-payment").on("click", function(){
      $("#form-edit-profile").hide();
      $("#form-edit-paymet-card").show();
    });
    $("#button-cancel-edit-payment").on("click", function() {
      $("#form-edit-profile").show();
      $("#form-edit-paymet-card").hide();
    });

    $("#submit-info-payment").on("click", function() {
      if ($(".billing-detail-form").valid()) {
        $("#submit-form-edit-payment").click();
        $("#form-edit-paymet-card").hide();
        $("#form-edit-profile").show();
      }
    });
  },
  validateForEditPayment: function() {
    $(".billing-detail-form").validate({
      rules: {
        "billing_detail[first_name]": {
          required: true
        },
        "billing_detail[last_name]": {
          required: true
        },
        "billing_detail[street_address]": {
          required: true
        },
        "billing_detail[city]": {
          required: true
        },
        "billing_detail[state]": {
          required: true
        },
        "billing_detail[zipcode]": {
          required: true,
          zipcode: true
        },
        "billing_detail[phone]": {
          required: true,
          phone: true
        },
        "billing_detail[email]": {
          required: true,
          email: true
        },
        "billing_detail[card_type]": {
          required: true
        },
        "billing_detail[name_card]": {
          required: true
        },
        "billing_detail[ccard_last4]": {
          required: true,
          number: true
        },
        "billing_detail[security_code]": {
          required: true,
          number: true
        }
      },
      messages: {
        "billing_detail[first_name]": {
          required: I18n.t("validate.billing.firstname.required")
        },
        "billing_detail[last_name]": {
          required: I18n.t("validate.billing.lastname.required")
        },
        "billing_detail[street_address]": {
          required: I18n.t("validate.billing.street_address.required")
        },
        "billing_detail[city]": {
          required: I18n.t("validate.billing.city.required")
        },
        "billing_detail[state]": {
          required: I18n.t("validate.billing.state.required")
        },
        "billing_detail[zipcode]": {
          required: I18n.t("validate.billing.zipcode.required")
        },
        "billing_detail[phone]": {
          required: I18n.t("validate.billing.phone.required")
        },
        "billing_detail[email]": {
          required: I18n.t("validate.billing.email.required"),
          email: I18n.t("devise.sessions.new.email_invalid")
        },
        "billing_detail[card_type]": {
          required: I18n.t("validate.billing.card_type.required")
        },
        "billing_detail[name_card]": {
          required: I18n.t("validate.billing.name_card.required")
        },
        "billing_detail[ccard_last4]": {
          required: I18n.t("validate.billing.card_number.required"),
          number: I18n.t("validate.billing.card_number.number")
        },
        "billing_detail[security_code]": {
          required: I18n.t("validate.billing.cvc.required"),
          number: I18n.t("validate.billing.cvc.number")
        }
      },
      errorPlacement: function(error, element) {
        error.appendTo(element.parent());
      },
      onfocusout: false,
      highlight: function(element) {
        $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
      },
      unhighlight: function(element) {
        $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
      }
    });
  },
  getSameCompanyAddress: function() {
    $("#billing_detail_same_as_company_address").on("change", function(){
      if ($(this).is(':checked')) {
        $.ajax({
          url: "/users/"+$("#user_id").val()+"/business_address",
          success: function(data){
            if (data.merchant_detail != null) {
              $(".may_disable").siblings(".error").remove();
              $(".may_disable").parent().removeClass("has-error");
              $("#billing_detail_first_name").val(data.user_detail.first_name);
              $("#billing_detail_last_name").val(data.user_detail.last_name);
              $("#billing_detail_street_address").val(data.merchant_detail.street_address);
              $("#billing_detail_city").val(data.merchant_detail.city);
              $("#billing_detail_state").val(data.merchant_detail.state);
              $("#billing_detail_zipcode").val(data.merchant_detail.zipcode);
              $(".may_disable").attr('readonly',true);
            }
            $("#billing_detail_phone").val(data.user_detail.phone_number);
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
  changeTypeInput: function() {
    $("#billing_detail_ccard_last4").focus(function(){
      $(this).attr("type", "text");
    });
    $("#billing_detail_ccard_last4").focusout(function(){
      $(this).attr("type", "password")
    });
  },
  addValidationEditUser: function() {
    $("#new_user").validate({
      rules: {
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
        }
      },
      messages: {
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
        "user[merchant_detail_attributes][phone_number]": {
          required: I18n.t("validate.edit_user.phone_number.required"),
          number: I18n.t("validate.edit_user.phone_number.number")
        },
        "user[merchant_detail_attributes][zipcode]": {
          required: I18n.t("validate.edit_user.zipcode.required"),
          number: I18n.t("validate.edit_user.phone_number.number")
        }
      },
      errorPlacement: function(error, element) {
        if (element.is(":radio"))
          error.appendTo(element.parent().next().next());
        else if (element.is(":checkbox"))
          error.appendTo($("#must_agree"));
        else if (element.is("#uploadBtn"))
          error.appendTo($("#uploadError"));
        else
          error.appendTo(element.parent());
      },
      onfocusout: false,
      highlight: function(element) {
        $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
      },
      unhighlight: function(element) {
        $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
      }
    });
  },
  addValidateImageAvatar: function() {
    var _URL = window.URL || window.webkitURL;
    $("#uploadBtn").change(function() {
      var fileExtension = ['jpeg', 'png', 'jpg'];
      if ($.inArray($(this).val().split('.').pop().toLowerCase(), fileExtension) == -1) {
        $('#uploadBtn').val("");
        alert("Your image should be in JPEG, JPG or PNG format. Please try again");
      }
    });
  },
  submitFormEditUser: function() {
    $("#submit-edit-profile").on("click", function() {
      $(".edit_user").submit();
    });
  },
  uploadPicProfile: function() {
    $(".logoUpload").on('click', function() {
      $("#image_avatar").click();
    })
  },
  reloadModalUploadAvatar: function() {
    $("#cancel-modal-change-avatar").on('click', function() {
      $("#crop-image-avatar").modal('hide');
      $("#crop-image-avatar, .modal-backdrop").remove();
      window.Pages['CommonJs'].uploadImageAfterChange("#image_avatar", "#upload-avatar");
    })
  },
  showLoaddingInCropImage: function() {
    $("#crop-avatar-upload").on('click', function() {
      console.log(I18n.t('js.cropping.processing'));
      window.Pages['CommonJs'].showLoading(I18n.t('js.cropping.processing'));
    })
  }
}

