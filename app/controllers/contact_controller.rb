class ContactController < ApplicationController

  layout "promotions_layout"
  # POST /contact
  def index
  	@back_url = request.referer
  end
  def send_contact
    data = params[:contact]
    UserMailer.delay.send_contact(data)
    @back_url = params[:back_url]
    render :contact_us_result
  end
end
