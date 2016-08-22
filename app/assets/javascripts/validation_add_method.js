jQuery.validator.addMethod('dateBefore', function(value, element, params) {
  if ($("#promotion_repeat option:selected").val() == "None" || $("#promotion_end_date_type option:selected").val() == 1 || $(params).val() == "")
  {
    return true;
  }
  else
  {
    var end = $(params).val().split("-");
    var end_date = new Date(end[2]+"-"+end[1]+"-"+end[0])
    var start_date = new Date(value.split("-")[2]+"-"+value.split("-")[1]+"-"+value.split("-")[0])
    return start_date < end_date;
  }
}, I18n.t("promotions.validation.must_be_before"));

jQuery.validator.addMethod('dateAfter', function(value, element, params) {
  if ($("#promotion_repeat option:selected").val() == "None")
  {
    return true;
  }
  else
  {
    var start = $(params).val().split("-");
    var start_date = new Date(start[2]+"-"+start[1]+"-"+start[0])
    var end_date = new Date(value.split("-")[2]+"-"+value.split("-")[1]+"-"+value.split("-")[0])
    return end_date > start_date
  }
}, I18n.t("promotions.validation.must_be_after"));

jQuery.validator.addMethod('less_than', function(value, element, params) {
  var end = $(params);
  return Number(value.replace(/[^0-9\.]+/g,"")) < Number(end.val().replace(/[^0-9\.]+/g,""));
}, I18n.t("promotions.validation.discount_can_be_than_price"));
jQuery.validator.addMethod("phone", function (phone_number, element) {
  phone_number = phone_number.replace(/\s+/g, "");
  var phoneRegExp = /^((\+)?[1-9]{1,12})?([-\s\.])?((\(\d{1,12}\))|\d{1,12})(([-\s\.])?[0-9]{1,12}){1,12}$/;
  return this.optional(element) || phone_number.match(phoneRegExp);
}, I18n.t("promotions.validation.phone_number_type"));

jQuery.validator.addMethod("zipcode", function (zipcode, element) {
  zipcode = zipcode.replace(/\s+/g, "");
  var zipcodeRegExp = /^\d{1,9}?([-\s])?(\d{1,9})?$/;
  return this.optional(element) || zipcode.match(zipcodeRegExp);
}, I18n.t("promotions.validation.zipcode_valid"));

jQuery.validator.addMethod('checkLinkGoogleMap', function(urlMap, element) {
  string_validate_1 = "https://www.google.com/maps/embed?pb=";
  string_validate_2 = "https://www.google.com/maps/embed/v1/place?q="
  if (urlMap.indexOf(string_validate_1) == 0 || urlMap.indexOf(string_validate_2) == 0) {
    return true;
  }
  else {
    return false;
  }
}, I18n.t("promotions.validation.not_correct_link"));

jQuery.validator.addMethod("day_in_past", function (value, element) {
  if(value != $(element).prev().val()){
    var entered_date = new Date(value.split("-")[2]+"-"+value.split("-")[1]+"-"+value.split("-")[0])
    var day_now = new Date();
    day_now.setMinutes(0, 0, 0);
    day_now.setHours(0);
    var sub = new Date(entered_date) - day_now;
    var logic;
    if (sub >= 0)
      logic = true;
    else
      logic = false;
    return logic;
  }
  else{
   return true
  }
}, I18n.t("promotions.validation.day_in_past"));

jQuery.validator.addMethod('timeAfter', function(value, element, params) {
  if($(params).val() == ""){
    return true
  }
  else{
    end_time = new Date("01/01/2007 " + value)
    start_time = new Date("01/01/2007 " + $(params).val())
    return end_time > start_time
  }
}, "Must be after corresponding start Time");

jQuery.validator.addMethod("timeBefore", function (value, element, params) {
  if($(params).val() == ""){
    return true
  }
  else{
    start_time = new Date("01/01/2007 " + value)
    end_time = new Date("01/01/2007 " + $(params).val())
    return start_time < end_time
  }
}, "Must be Before corresponding End Time");

jQuery.validator.addMethod('segmentable', function(value, element) {
  if($("#promotion_start_date").val() == "" || $("#promotion_end_date").val() == ""){
    return true
  }
  else{
    start_time = new Date("01/01/2007 " + $("#promotion_start_time").val())
    end_time = new Date("01/01/2007 " + $("#promotion_end_time").val())
    time_diff = (end_time-start_time)/1000
    segment_value = time_diff/3600
    return parseFloat($("#promotion_booking_detail_attributes_booking_duration").val()) < segment_value
  }
}, "Must be after corresponding start Time");

jQuery.validator.addMethod('checkFileSize', function(value, element, param) {
    return this.optional(element) || (element.files[0].size <= param)
}, "File size must be less than 2MB");

jQuery.validator.addMethod('checkFileType', function(value, element) {
  var ext = element.files[0].type.split('/')[1];
   return $.inArray(ext, ['gif','png','jpg','jpeg']) >= 0
}, "File type must be 'gif','png','jpg','jpeg'");

