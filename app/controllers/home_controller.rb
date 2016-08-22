class HomeController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :check_password_page, :check_pass]
  skip_before_filter :check_password, :only => [:check_password_page, :check_pass]
  skip_before_filter :authenticate_user!, :only => [:privacy_policy]
  layout "promotions_layout", only: [:merchant_page]

  def index
  	redirect_to merchant_page_path and return  if current_user && current_user.user_type == "merchant"
  end

  def check_pass
    if params[:check][:pass] == CHECK_PASSWORD
      session[:check_password] = "1"
      redirect_to root_path
    else
      render "check_password_page", layout: "home_layout"
    end
  end

end