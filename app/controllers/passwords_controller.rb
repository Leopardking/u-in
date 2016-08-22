class PasswordsController < Devise::PasswordsController
  respond_to :html if mimes_for_respond_to.empty?

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      flash[:notice] = I18n.t("devise.passwords.send_instructions")
      redirect_to new_user_session_path
    else
      flash.now[:alert] = I18n.t("devise.passwords.new.email_not_existed")
      render :new
    end
  end
end
