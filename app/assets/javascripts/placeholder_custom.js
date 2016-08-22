function custome_placeholder(){
  $("body").on("focusin",".custom-placeholder input,.custom-placeholder textarea",function(){
    $(this).closest(".custom-placeholder").find("label").css("display","none");
  })

  $("body").on("focusout",".custom-placeholder input,.custom-placeholder textarea",function(){
    if ($(this).val() == ""){
      $(this).closest(".custom-placeholder").find("label").css("display","block");
    }
  })
  $(".custom-placeholder input,.custom-placeholder textarea").each(function(){
    if ($(this).is(":focus")) {
      $(this).focusin();
    }
    if ($(this).val() != ""){
      $(this).focusin();
    }
  })
  $(".custom-placeholder").on("input paste drop change keyup", "input, textarea", function(){
    if ($(this).val().length) {
      $(this).focusin();
    }
  })
}
