function contactus_validation() {
  $("#contactUs-form").validate({
    rules: {
      "contact[firstname]": {
        required: true,
      },
      "contact[lastname]": {
        required: true,
      },
      "contact[phone]": {
        required: true,
        phone: true
      },
      "contact[email]": {
        required: true,
        email: true
      },
      "contact[message]": {
        required: true,
      },
    },  
    message: {
      "contact[firstname]": {
        required: I18n.t("validate.biling.firstname.required"),
      },
      "contact[lastname]": {
        required: I18n.t("validate.biling.lastname.required"),
      },
      'contact[phone]': {
        required: I18n.t("promotions.validation.phone_number"),
        number: I18n.t("promotions.validation.phone_number_type")
      },
      'contact[email]': {
        required: I18n.t('validate.contact_form.email.required'),
        email: I18n.t('validate.contact_form.email.invalid')
      },
      'contact[message]': {
        required: I18n.t('validate.contact_form.message.required')
      }
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
  })
}

$(function(){
contactus_validation()
})