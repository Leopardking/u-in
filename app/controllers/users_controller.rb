class UsersController < ApplicationController
  load_and_authorize_resource only: [:show, :edit, :delete_account, :destroy, :send_reset_password]
  # GET /index
  # This action have 2 params: :search_email and :user_type
  # :search_email is string for search like with column Email.
  # :user_type is string for search with column user_type (ex: 'client' or 'merchant')
  def index
    if params[:search_email] && params[:user_type] # if search like by email and have filter by user_type
      if params[:user_type] =='all'
        @users = User.where(["LOWER(email) like ? and admin=false", "%#{params[:search_email].downcase}%" ]).order("created_at DESC").page(params[:page])
      else
        @users = User.where(["LOWER(email) like ? and user_type=? and admin=false", "%#{params[:search_email].downcase}%","#{params[:user_type]}" ]).order("created_at DESC").page(params[:page])
      end
    else # if filter only by user_type
      if params[:user_type]=='client' ||  params[:user_type]=='merchant'
        @users= User.where(user_type: params[:user_type], admin: false).order("created_at DESC").page(params[:page])
      else #default GET action
        @users= User.where(admin: false).order("created_at DESC").page(params[:page])
      end
    end
  end
  ##
  # GET
  def new
    @user= User.new
  end

  # POST
  def new_step2
    if params[:user][:user_type] == "merchant"
      session[:user_params] = user_params
      @user = User.new
      render 'add_account_merchant.js.erb'
    else
      password_length = 8
      password = Devise.friendly_token.first(password_length)
      @user = User.new(user_params.merge(password: password))
      @user.skip_confirmation!
      if @user.save
        data = {}
        data[:email] = params[:user][:email]
        data[:password] = password
        UserMailer.delay.send_email_client(data)
        flash[:notice]= t("users.new.new_successful")
      end
    end
  end
  # POST
  def create
    authorize! :manage, User
    password_length = 8
    password = Devise.friendly_token.first(password_length)
    @user = User.new(user_params_with_merchant.merge(password: password))
    @user.skip_confirmation!
    if @user.save
      data = {}
      data[:email] = user_params_with_merchant[:email]
      data[:password] = password
      data[:merchant_data] = user_params_with_merchant[:merchant_detail_attributes]
      UserMailer.delay.send_email_merchant(data)
      flash[:notice]= t("users.new.new_successful")
    end
  end
  # PUT /user_management/update_info_user
  def update
    if merchant_account_update_params[:virtual_money].blank?
      @merchant_detail = MerchantDetail.find_by_id (merchant_account_update_params[:merchant_detail_attributes][:id])
      if @merchant_detail.update(merchant_account_update_params[:merchant_detail_attributes])
        flash[:notice]= t("users.edit_one_profile.saved_successful")
      end
    else
      user = User.find_by_id([params[:id]])
      amount = merchant_account_update_params[:virtual_money].to_f - user.virtual_money
      if user.update(:virtual_money => merchant_account_update_params[:virtual_money].to_f)
        HistoryVMoney.create(amount: amount, user_id: user.id, action: 2,   )
        flash[:notice]= t("users.edit_one_profile.saved_successful")
      else
        flash[:alert]= t("users.edit_one_profile.unsave_msg")
      end
    end
  end
  ##
  # GET /show_one_profile/:id
  def show
  end
  ##
  # GET /edit_one_profile/:id
  def edit
  end
  ##
  # GET
  def delete_account
  end
  ##
  # DELETE
  # Note: Can't not delete user when user still have promotion active.
  # And must be alert can't be delete, reason abc ...
  def destroy
    if @user.destroy
      flash[:notice]= t("users.delete_one_profile.deleted_successful")
    end
  end
  ##
  # POST
  def send_reset_password
    @user.send_reset_password_instructions
  end

  def business_address
    billing_detail = current_user.billing_detail.nil? ? nil : current_user.billing_detail.as_json(only: ["first_name", "last_name", "street_address", "city", "zipcode", "state", "street_address_2", "email", "phone"])

    merchant_detail = current_user.merchant_detail.nil? ? nil : current_user.merchant_detail.as_json(only:  ["street_address", "city", "state", "zipcode"])
    json_response = {
      billing_detail: billing_detail,
      merchant_detail: merchant_detail,
      user_detail: current_user.as_json(only: ["phone_number", 'first_name', 'last_name'])
    }
    render json: json_response
  end

  def crop_avatar
    @avatar = image_service.update_crop_avatar(image_params, params[:avatar_id])
    if @avatar.errors.empty?
      @avatar.reprocess_avatar!
      @avatar_url = @avatar.avatar.url(:medium)
    else
      render 'crop_avatar_fail.js.erb'
    end
  end
  ##
  private
  # Params
  def merchant_account_update_params
    params.require(:user).permit(:email, :phone_number, :virtual_money, :merchant_detail_attributes => [:id,:business_name, :street_address, :city, :state, :zipcode])
  end

  def user_params
    params.require(:user).permit(:email, :email_confirmation,:user_type, :agree_with_tos, :phone_number)
  end

  def user_params_with_merchant
    merchant_account_update_params.merge!(session[:user_params])
  end

  def image_params
    params.required(:image).permit(:image, :avatar, :image_no, :description_image, :image_default, :crop_x, :crop_y, :crop_w, :crop_h, :user_id, :img_id, :using_image)
  end

  def image_service
    @images ||= ImageService.new()
  end
end
