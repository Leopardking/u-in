window.Pages['CropImageProcess'] =
  init: ->
  updateCropImage: (coords) ->
    if $("body").find("img").hasClass("crop-avatar-user")
      # Get ratio for crop avatar
      ratio = $("#show-avatar-crop")[0].naturalHeight/$("#show-avatar-crop").height()
    else
      # Get ratio for crop image promotion
      ratio_w = $("#image_promotion_large")[0].naturalWidth/$("#image_promotion_large").width()
      ratio_h = $("#image_promotion_large")[0].naturalHeight/$("#image_promotion_large").height()
      ratio = Math.max(ratio_w,ratio_h);

    $('#image_crop_x').val(Math.round(coords.x * ratio))
    $('#image_crop_y').val(Math.round(coords.y * ratio))
    $('#image_crop_w').val(Math.round(coords.w * ratio))
    $('#image_crop_h').val(Math.round(coords.h * ratio))
  cropImageChange: (selectElem)->
    jcropObject = $.Jcrop selectElem,
      onChange: window.Pages['CropImageProcess'].updateCropImage
      onSelect: window.Pages['CropImageProcess'].updateCropImage
      setSelect: [50, 50, 90, 90]
      aspectRatio: 16/9
  setRatioImage: ->
    width_default = $('.img-responsive').first().width()
    $('.img-responsive').css "height", width_default * 6/9

