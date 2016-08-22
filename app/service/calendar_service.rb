class CalendarService < BaseService
  class << self
    def init_calendar current_user,params
      if params[:date].present?
        agendaView = AGENDA_DAY
        default_date = params[:date]
      else
        agendaView = params[:agendaView].nil? ? AGENDA_MONTH : params[:agendaView]
        default_date = params[:default_date].nil? ? Date.today.to_s : params[:default_date]
      end
      promotion = current_user.promotions.running_promotions(false).includes(:booking_detail).first
      if current_user.charge_payment && current_user.time_charge >= Time.zone.now
        booking_free = 0
      else
        booking_free = Booking::MAXIMUM_BOOKING_FREE - current_user.booking_free
      end
      result = {
        agendaView: agendaView,
        default_date: default_date,
        promotion: promotion,
        booking_free: booking_free
      }
    end

    def export_to_google_calendar current_user, response, promotion_id
      
      current_user.google_refresh_token = response['refresh_token'] if response['refresh_token']
      current_user.save
      client = Signet::OAuth2::Client.new( access_token: response['access_token'], token_credential_uri: 'https://accounts.google.com/o/oauth2/token', client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'), client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'), refresh_token: current_user.google_refresh_token
        )
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = client
      promotion = Promotion.find promotion_id

      if promotion.end_date.nil?
        promotion.end_date = promotion.start_date + 3.months
      end
      
      promotion_events = Promotion.generate_normal_events( promotion_id, promotion.start_date, promotion.end_date )
      
      timeMin = promotion.start_date.to_datetime
      timeMax = promotion.end_date.to_datetime
      list_events = service.list_events('primary',
                                      single_events: true,
                                      order_by: 'startTime',
                                      time_max: timeMax.to_s,
                                      time_min: timeMin.to_s,
                                      fields: 'items(id,summary,start)')

      # add Promotion Event
      if promotion_events
        promotion_events.each do |promotion_event|

          event = {
            summary: promotion_event[:title],
            start: {
              date_time: promotion_event[:start].to_datetime
            },
            end: {
              date_time: promotion_event[:end].to_datetime
            }
          }

          service.insert_event('primary', event, send_notifications: false) unless check_event_exist(list_events, event) 
        end
      end

      # add booking_events
      booking_events = Booking.where(promotion_id: promotion_id)

      if booking_events
        booking_events.each do |booking_event|

          event = {
            summary: "#{booking_event.first_name} #{booking_event.last_name}",
            start: {
              date_time: booking_event.start_time.to_datetime
            },
            end: {
              date_time: booking_event.end_time.to_datetime
            }
          }
          if booking_event.check_discount
            event[:color_id] = "10"
          end

          service.insert_event('primary', event, send_notifications: false) unless check_event_exist(list_events, event) 
        end
      end

    end

    def check_event_exist list_events, event
      list_events.items.each do |item|
        if item.start.date_time.to_i == event[:start][:date_time].to_i && item.summary ==event[:summary]
          return true
        end
      end
      return false
    end

  end
end