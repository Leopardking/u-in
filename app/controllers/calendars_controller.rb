class CalendarsController < ApplicationController

  layout "promotions_layout"
  before_action :authenticate_user!, :except => [:get_events,:get_segmented_events]

  def index
    @booking = Booking.new
    @billing_card = BillingDetail.new
    init_calendar = CalendarService.init_calendar(current_user,params)
    @agendaView = init_calendar[:agendaView]
    @default_date = init_calendar[:default_date]
    @promotion = init_calendar[:promotion]
    @booking_free = init_calendar[:booking_free]
  end

  def get_events
    #show inactive promotion
    if to_boolean(params[:inactive_promotion]).present?
      # set variable inactive promotion to view can check to show calendar
      if params[:id]
      # check when preview promotion
        inactive_promotions_ids = params[:id]
      else
        inactive_promotions_ids = current_user.promotions.running_promotions(true).map(&:id)
      end
      promotion_events = Promotion.generate_normal_events(inactive_promotions_ids, params[:start_date], params[:end_date], true)
    else
      promotion_events = Promotion.generate_normal_events(params[:promotion_id], params[:start_date], params[:end_date])
    end
    render json: promotion_events
  end

  def get_segmented_events
    # authorize! :manage, Promotion
    promotion_events = Promotion.generate_segments_events(params[:promotion_id], params[:start_date], params[:end_date], params[:new_calendar])
    render json: promotion_events
  end

  def get_promotion_for_blackout
    @promotion = Promotion.find(params[:promotion_id])
    @selected_date = params[:selected_date]
    respond_to do |format|
      format.js
    end
  end

  def export_to_google_calendar
    client = Signet::OAuth2::Client.new({
      client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
      client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: url_for(action: "export_to_google_calendar"),
      code: params[:code]
    })
    promotion_id = session[:promotion_id]
    session.delete(:promotion_id)

    response = client.fetch_access_token!
    CalendarService.export_to_google_calendar(current_user, response, promotion_id)

    flash[:notice]= t("calendars.export_to_google_calendar.succesfull")
    redirect_to promotions_path
  end
end