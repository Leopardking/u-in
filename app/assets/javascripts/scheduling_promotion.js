// function to check array uniqueness
function unique(list) {
    var result = [];
    $.each(list, function(i, e) {
        if ($.inArray(e, result) == -1) result.push(e);
    });
    return result;
}

$(document).ready(function(){
    inner_html = $("#day_count").html()
	var days = [];
	$(".time-field").timepicker({ 'timeFormat': 'h:i a' })
	$( "#promotion_start_date, #promotion_end_date" ).datepicker({
		showButtonPanel: true
	});
	$( "#promotion_start_date, #promotion_end_date" ).datepicker( "option", "showAnim", "slideDown" );
	$( "#promotion_start_date, #promotion_end_date" ).datepicker( "option", "dateFormat", "dd-mm-yy" );

	// Set values after date picker is initialized
	$( "#promotion_start_date, #promotion_end_date" ).each(function(){
	  $(this).val($(this).attr("value"))
	})

	//Jquery UI datepicker today date function
	$.datepicker._gotoToday = function(id) {
	    var target = $(id);
	    var inst = this._getInst(target[0]);
	    if (this._get(inst, 'gotoCurrent') && inst.currentDay) {
        inst.selectedDay = inst.currentDay;
        inst.drawMonth = inst.selectedMonth = inst.currentMonth;
        inst.drawYear = inst.selectedYear = inst.currentYear;
	    }
	    else {
        var date = new Date();
        inst.selectedDay = date.getDate();
        inst.drawMonth = inst.selectedMonth = date.getMonth();
        inst.drawYear = inst.selectedYear = date.getFullYear();
        // the below two lines are new
        this._setDateDatepicker(target, date);
        this._selectDate(id, this._getDateDatepicker(target));
	    }
	    this._notifyChange(inst);
	    this._adjustDate(target);
	}

	setTimeout(function(){
	  $("#promotion_end_date_type, #promotion_repeat, #promotion_booking_detail_attributes_booking_criterion").trigger("change")
	}, 100)

	$("#promotion_end_date_type").on("change", function(){
	  selected_end_type = $(this).find("option:selected").val()
	  if(selected_end_type == 1){
	    $("#end_date").addClass("temp_hide")
	    $("#promotion_end_date").val("")
	  }
	  else if(selected_end_type == 2){
	    $("#end_date").removeClass("temp_hide")
	  }
	}).trigger("change")

	// ON change of repeat dropdown
	$("#promotion_repeat").on("change", function(){
    $(".bkg-tx p").text("Day(s)")
    $("#weekly_fields").next("label").remove()
    $(".bkg-days").removeClass("temp_hide")
    if ($( "#promotion_end_date_type option:selected" ).text() == "By") {
      $("#end_date").removeClass("temp_hide")
    };
    $(".bkg-days").next(".bkg-tx").removeClass("temp_hide")
    $("#end_date").prev(".firstcol-row").removeClass("temp_hide")
	  $("select#promotion_days_of_week option:selected").removeAttr("selected")
    selected_value = $(this).find("option:selected").val()
    $("#header_text").text(selected_value)
    $("#weekly_fields,#monthly_fields").addClass("temp_hide")
    if(selected_value == "Weekly"){
      days = $("#days").val().split(',');
    	$(days).each(function(i, day){
    		$("#weekly_fields ul li[data-value='"+day+"']").find("a").addClass("day-highlight")
    	})
    	$(".bkg-tx p").text("Week(s)")
    	$("#weekly_fields").removeClass("temp_hide")
    }
    else if(selected_value == "Monthly"){
    	$("#monthly_fields").removeClass("temp_hide")
    	$("#promotion_occurrence").trigger("change")
    	$(".bkg-days, .bkg-tx").addClass("temp_hide")
    }
    else if(selected_value == "None"){
      $("#end_date, .bkg-days").addClass("temp_hide")
      $(".bkg-days").next(".bkg-tx").addClass("temp_hide")
      $("#end_date").prev(".firstcol-row").addClass("temp_hide")
    }
	});

	// Day selector
	$("#weekly_fields li").click(function(){
	  $("#weekly_fields").next("label").remove()
	  if($(this).find("a").hasClass("day-highlight")){
	  	$(this).find("a").removeClass("day-highlight")
	  	days.remove($(this).data("value"), true)
	  }
	  else{
	  	$(this).find("a").addClass("day-highlight")
	    days.push($(this).data("value"))
	  }
	  // Add only the unique elements in the array and added it to the form_field
	  days = unique(days)
	  $("#days").val(days)
	})

	// Monthly view, select frequency
	$("#promotion_occurrence").on("change", function(){
	  $("#day_count, #day_dropdown").addClass("temp_hide")
	  $("#day_count").html("")
	  $(this).parents(".frm-row1").find(".iccon-row, .seccol-row").removeClass("temp_hide")
	  selected_frequency = $(this).find("option:selected").val()
	  if(selected_frequency == 0){
	  	$("#day_count").removeClass("temp_hide").html(inner_html)
	  }
	  else{
	  	$("#day_dropdown").removeClass("temp_hide")
	  }
	})
})
