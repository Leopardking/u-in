class UserMailer < ActionMailer::Base

  default to: "customersupport@u-in.com"
  default from: "no-reply@dreamorbit.com"
  ##
  # Send contact email to Admin
  #
  # Input:
  #   + data[:email]
  #   + data[:message]
  def send_contact(data = {})
    @data = data
    mail(subject: I18n.t("user_mailer.send_contact.subject", email: @data[:email]), to: "contact@u-in.com", from: @data[:email])
  end

  ##
  # Send merchant contact
  #
  # Input:
  #   + data[:email]
  #   + data[:message]
  def send_merchant_contact(data={})
    @email = data[:email]
    @message = data[:message]
    mail(subject: I18n.t("user_mailer.send_merchant_contact.subject", email: @email, to: "thuyltt@nustechnology.com"))
  end

  ##
  # Send infomation about account to client.
  def send_email_client(data = {})
    @email = data[:email]
    @password = data[:password]
    mail(to: @email)
  end
  def send_email_merchant(data = {})
    @email = data[:email]
    @password = data[:password]
    @merchant_data = data[:merchant_data]
    mail(to: @email)
  end
  def send_inform_admin (data = {})
    @email = 'customersupport@u-in.com'
    @data = data
    mail(to: @email)
  end
  def send_suggest_new_category_to_admin(data ={})
    @email = CATEGORY_REQUEST_EMAIL
    @data = data
    mail(to: @email,subject: I18n.t("user_mailer.send_suggest_new_category_to_admin.subject"))
  end

  def signed_up_success(data = {})
    @email = data[:email]
    @data = data
    mail(to: @email)
  end

  def send_email_to_merchant_books(booking_params, merchant_data, data={}, options={})
    @email = data.email
    @data = data
    @booking = booking_params
    @merchant_data = merchant_data
    @options = options.with_indifferent_access
    Time.zone = @options[:zone_name] if @options[:zone_name]
    Phoner::Phone.default_country_code = '1' # country code of US
    mail(to: @email, subject: I18n.t("user_mailer.send_email_to_merchant_books.subject", promotion_name: data.promotion.name))
  end
end
