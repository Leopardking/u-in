module UsersHelper
  def user_error_messages!
    return '' if @user.errors.empty?

    messages = @user.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t('errors.messages.not_saved',
      count: @user.errors.count,
      resource: @user.class.model_name.human.downcase)

    html = <<-HTML
    <div class="alert alert-danger">
      <button type="button" class="close" data-dismiss="alert">x</button>
      <ul> #{messages} </ul>
    </div>
    HTML
    return html
  end
  def user_error_messages?
    @user.errors.empty? ? false : true
  end

  # Get id of image if user have avatar
  def get_image_avatar_id user
    user.images.find_by_using_image("avatar")
  end
end
