class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # This filter could go anywhere the user needs to have a valid email address to access
  before_filter :check_password
  before_action :authenticate_user!
  before_filter :define_header_title
  before_filter :set_current_user
  around_action :set_time_zone
  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  rescue_from ActionController::RoutingError, :with => :render_not_found
  ##
  def check_password
    render("home/check_password_page", layout: "home_layout") and return unless session[:check_password] == "1"
  end
  # Set page header title
  def define_header_title
    case params[:controller]
      when "faqs"
        @header_text = t("page_header.faqs")
      when "contact"
        @header_text = t("page_header.contact")
      when "registrations"
        if params[:action] == "edit_password"
          @header_text = t("page_header.change_password")
        elsif params[:action] == "edit"
          @header_text = t("page_header.account_settings")
        else
          @header_text = t("page_header.register")
        end
      when "users"
        @header_text = t("page_header.user_management")
      when "home"
        @header_text = t("page_header.home")
      when "devise/sessions"
        @header_text = t("page_header.login")
      when "sessions"
        @header_text = t("page_header.login")
      when "devise/passwords"
        @header_text = t("page_header.forgot_password")
      when "devise/confirmations"
        @header_text = t("page_header.resend_confirm")
      when "promotions"
        case params[:action]
        when "contact"
          @header_text = t("page_header.contact_merchant")
        else
          @header_text = t("page_header.promotions")
        end
      when "categories"
        @header_text = t("page_header.categories")
      when "my_activities"
        @header_text = t("page_header.my_activities")
      when "activities"
        @header_text = t("page_header.activities")
      when "history_v_moneys"
        @header_text = t("page_header.history_refund")
      when "calendars"
        @header_text = t("page_header.calendars")
      else
        @header_text = params[:controller]
    end
  end

  ##
  # Handle Unauthorized Access
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = t("access_denied")
    redirect_to root_url
  end

  def after_sign_out_path_for(resource)
    return new_user_session_path
  end

  def to_boolean(str)
    str == 'true'
  end

  #called by last route matching unmatched routes.  Raises RoutingError which will be rescued from in the same way as other exceptions.
  def raise_not_found!
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end

  private
  def set_time_zone
    old_time_zone = Time.zone
    Time.zone = browser_timezone if browser_timezone.present?
    yield
  ensure
    Time.zone = old_time_zone
  end

  def browser_timezone
    cookies["browser.timezone"]
  end

  #render 404 error
  def render_not_found(e)
    render :file => "#{Rails.root}/public/404.html", :layout => false, :status => :not_found
  end

  def set_current_user
    gon.current_user = current_user.nil? ? {current_user_id: nil} : { current_user_id: current_user.id }
  end

  protected
  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  def after_sign_up_path_for(resource)
    'auth/sign_up#/'
  end
end
