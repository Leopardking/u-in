window.Pages['SocialShare'] =
  init: ->
    this.manageSocialShare()
  manageSocialShare: ->
    _this = $(this)
    title = _this.name
    id = $("#promotion_share_id").text()
    description = _this.description
    newURL = window.location.protocol + '//' + window.location.host
    link = newURL + Routes.promotion_path(id)
    image = newURL + $('#image_share').attr('src')
    $('a.fb-share-button,a.twitter-share-button,a.google-share-button,a.linkedin-share-button').click (e) ->
      e.preventDefault()
    $('.share').ShareLink
      title: title
      text: description
      image: image
      url: link
      class_prefix: 's_'
      width: 640
      height: 480

