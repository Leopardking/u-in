class RegistrationsController < Devise::RegistrationsController
  layout "promotions_layout", only: [:edit]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy, :billing_card, :create_billing_card]

  # POST /auth/
  def new_profile
    if params[:provider].present?
      #  User regis by auth social media
      user = User.new(
        name: params[:user][:name],
        email: params[:user][:email],
        password: DEFAULT_PASSWORD, #set password default with provider
        user_type: params[:user][:user_type]
      )
      user.save!
      identity = Identity.find_for_oauth(params[:provider], params[:uid])
      if identity.user != user
        identity.user = user
        identity.save!
      end
      sign_in_and_redirect user
    else
      # User regis by account normal
      params[:user][:user_type] == "client"? self.resource = @user : self.resource = resource
      # Check if merchant or client
      user_params = (params[:user][:user_type] == User::USER_TYPE[:merchant] ? merchant_account_update_params : client_account_update_params).except(&:blank?)
      build_resource(user_params)
      if resource.save
        #send email to user after sign up is successfully
        UserMailer.delay.signed_up_success(resource)
        flash[:notice]= t("devise.registrations.signed_up")
        sign_in_and_redirect resource
      else
        clean_up_passwords resource
        render :new
      end
    end
  end
  ##
  # GET /auth/edit
  def edit
    @billing_card = current_user.billing_detail.nil? ? BillingDetail.new : current_user.billing_detail
    super
  end

  ##
  # PUT /auth
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    # Check if merchant or client
    update_params = (resource.user_type == User::USER_TYPE[:merchant] ? merchant_account_update_params : client_account_update_params).except(&:blank?)
    if params[:user][:password].present?
      if @user.update_attributes(update_params)
        image_service.update_user_id_for_avatar(current_user, params[:pic_profile])
        set_flash_message :notice, :updated
        # Sign in the user bypassing validation in case his password changed
        sign_in resource, :bypass => true
        redirect_to after_update_path_for(resource)
      else
        respond_with_navigational(resource) do
          render :edit
        end
      end
    else
      if @user.update_without_password(update_params)
        image_service.update_user_id_for_avatar(current_user, params[:pic_profile])
        set_flash_message :notice, :updated
        # Sign in the user bypassing validation in case his password changed
        sign_in @user, :bypass => true
        redirect_to after_update_path_for(resource)
      end
    end
  end
  ##
  # GET billing_card
  def billing_card
    authorize! :add_card, User
    @billing_card = BillingDetail.new
  end

  def create_billing_card_merchant
    authorize! :add_card, User
    if current_user.billing_detail.nil?
      current_user.create_billing_detail(marchant_billing_card_params)
    else
      current_user.billing_detail.update_attributes(marchant_billing_card_params)
    end
    @billing_card = current_user.billing_detail
  end

  # POST billing_card
  def create_billing_card
    authorize! :add_card, User
    @billing_card = current_user.billing_details.new(client_account_update_params)
    if params[:user][:always_use]==1
      card_another= BillingDetail.where(:user_id => current_user.id)
      card_another.update_all(:always_use => false)
    end
    if @billing_card.save
      redirect_to edit_user_registration_path, notice: t("devise.registrations.edit.billing_card_msg")
    end
  end
  #GET card
  def card
    @card= BillingDetail.find_by_id(params[:id])
  end
  #PUT card
  def update_card
    card= BillingDetail.find_by_id(params[:id])
    card_another= BillingDetail.where(:user_id => card.user_id)
    card_another.update_all(:always_use => false)
    if card.update(:always_use => true)
      flash[:notice] = t("devise.registrations.edit.change_sucess_msg")
      redirect_to edit_user_registration_path
    else
      render "card"
    end
  end
  ##
  # GET confirm
  def comfirmation_success
    if current_user.user_type == 'client'
      render "devise/registrations/comfirmation_success"
    else
      redirect_to root_url
    end
  end
  ##
  # GET /auth/change_password
  def edit_password
    build_resource({})
  end
  ##
  # GET
  def check_user_unique
    @user = User.find_by_email(params[:user][:email])
    render :json => !@user
  end

  def after_inactive_sign_up_path_for(resource)
    respond_to?(:root_path) ? root_path : "/"
  end

  def index_regis
  end

  def check_email_regis
    info= [:first_name, :last_name, :email, :password, :phone_number]
    info.each do |info_type|
      session[info_type] = params[:user][info_type]
    end
    @email = params[:user][:email]
    @user = User.find_by_email @email
    if @user
      flash.now[:alert] = I18n.t("devise.registrations.new.email_existed", email_user: @email).html_safe
      render "account_regis"
    else
      redirect_to new_user_registration_path
    end
  end
  def account_regis
  end

  private
  # Params
    def merchant_account_update_params
      params.require(:user).permit(:first_name, :last_name, :phone_number, :email, :email_confirmation, :password, :password_confirmation, :user_type, :agree_with_tos, :current_password, :edit_account_type, :avatar_url, merchant_detail_attributes: [:business_name, :street_address, :city, :state, :zipcode, :id, :business_desc])
    end

    def marchant_billing_card_params
      if params[:billing_detail][:ccard_last4]
        customer = Stripe::Customer.create(
          card: params[:billing_detail][:stripe_profile_token],
          description: params[:billing_detail][:email]
        )
        params[:billing_detail][:customer_id] = customer.id
      end
      params[:billing_detail][:ccard_last4] = params[:billing_detail][:ccard_last4].last(BillingDetail::LAST_NUMBER_CARD)
      params.require(:billing_detail).permit(:card_type, :ccard_last4, :first_name, :last_name, :street_address, :street_address_2, :city, :state, :zipcode, :always_use, :customer_id, :same_as_company_address, :email, :phone, :name_card, :exp_month, :exp_year, :security_code)
    end

    def client_account_update_params
      if params[:user][:ccard_last4]
        customer = Stripe::Customer.create(
        :card => params[:user][:stripe_profile_token],
        :description => params[:user][:email]
        )
        params[:user][:customer_id] = customer.id
      end
      params.require(:user).permit(:phone_number, :email, :email_confirmation, :password, :password_confirmation, :current_password,:user_type, :agree_with_tos,:card_type, :ccard_last4,:stripe_profile_token, :first_name, :last_name, :street_address, :city, :zipcode, :state, :always_use, :customer_id)
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :phone_number, :email, :email_confirmation,:password, :user_type, :agree_with_tos, :password_confirmation, :current_password)
    end

    def image_service
      @avatar ||= ImageService.new()
    end

end
