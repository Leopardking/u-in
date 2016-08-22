function validation_category () {
  $(".frm_category").each(function(){
    $(this).validate({
      rules: {
        "category[name]": {
          required: true,
          maxlength: 255
        }
      },
      messages: {
        "category[name]": {
          required: I18n.t("categories.categories.category_require"),
          maxlength: I18n.t("categories.categories.category_max")
        }
      },
      onfocusout: false,
      highlight: function(element) {
        $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
      },
      unhighlight: function(element) {
        $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
      }
    });
  });
  if($( "#category_name" ).length > 0){
    $( "#category_name" ).rules( "add", {
      remote: '/categories/check_categories_unique',
      messages: {
        remote: I18n.t("categories.form.category_exist")
      }
    });
  }
}
$(document).ready(function() {
  if ($(".frm_category").length > 0)
  {
    validation_category();
  }

  $("body").on('submit', '#new_category', function() {
    $(this).find('button').prop('disabled', true);
  });
  $("body").on('click', '#btn_request_category', function() {
    $('#new_category')[0].reset();
    $("#category_name").parent().parent().removeClass("has-success");
    $("#category_name").parent().parent().removeClass("has-error");
    $(".error").remove();
  });
  $( "#categories_list_table" ).keypress(function( event ) {
    if ( event.which == 13 ) {
    var _name = $("#search_name").val();
    if (_name != "")
    {
      $.ajax({
        type: "GET",
        url: 'categories',
        data: { name: _name},
        async: true,
        success: function(data) {
        }
      });
    }
    }
  });
  $("body").on('click', '#btn_search_name', function() {
    var _name = $("#search_name").val();
    if (_name != "")
    {
      $.ajax({
        type: "GET",
        url: 'categories',
        data: { name: _name},
        async: true,
        success: function(data) {
        }
      });
    }
  });
});
