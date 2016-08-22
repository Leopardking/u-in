class SessionsController < Devise::SessionsController

  def index
  end

  def check_email_present
    session[:email] = params[:email_user]
    @email = params[:email_user]
    @user = User.find_by_email(@email)
    if @user
      redirect_to new_user_session_path
    else
      flash.now[:alert] = I18n.t("devise.sessions.new.email_not_existed", email_user: @email).html_safe
      render :index
    end
  end

  # DELETE /resource/sign_out
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    flash[:notice] = I18n.t(".devise.sessions.new.sign_out")
    yield if block_given?
    redirect_to new_user_session_path
  end

  def redirect
    
    client = Signet::OAuth2::Client.new({
      client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
      client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: url_for(controller: "calendars", action: "export_to_google_calendar")
    })
    session[:promotion_id] = params[:promotion_id]
    redirect_to client.authorization_uri.to_s
  end

end
