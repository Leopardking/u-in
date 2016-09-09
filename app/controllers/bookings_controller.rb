require "stripe"
class BookingsController < ApplicationController

  def create_new_booking
    @numbers_booked = params[:numbers_booked].to_i
    @booking_free = current_user.booking_free
    @billing_card = BillingDetail.new
    status_charge = booking_service.check_status_charge current_user, params[:check_status]
    @info_booking = nil
    @message = nil
    @error_booking = false
    @number_free_bookings = Booking::MAXIMUM_BOOKING_FREE - @booking_free
    @promotion = Promotion.find(params[:booking][:promotion_id])
    bookings_per_duration = @promotion.booking_detail.bookings_per_duration
    start_time_tz = params[:booking][:start_time].present? ? params[:booking][:start_time].to_time.utc.strftime("%Y-%m-%d %H:%M:%S") : nil
    end_time_tz = params[:booking][:end_time].present? ? params[:booking][:end_time].to_time.utc.strftime("%Y-%m-%d %H:%M:%S") : nil
    totals_has_booked = Booking.booked_totals(params[:booking][:promotion_id], start_time_tz, end_time_tz).size
    session[:@info_booking] = booking_params
    session[:numbers_booked] = params[:numbers_booked]
    session[:promotion_booking] = params[:promotion_booking] || nil
    #format params
    @format_booking_params = booking_params
    # if current_user.user_type == User::USER_TYPE[:merchant]
    if current_user.user_type.eql? "client" || "merchant"
      # check number booking of users has exceed avaiable booking
      # to set value in the popup
      @avaiable_booking = BookingService.calculate_avaiable_booking(params[:booking], @promotion)
      if @numbers_booked > (bookings_per_duration - totals_has_booked)
        @error_booking = true
        @message = t(".over_booking_message", number: (bookings_per_duration - totals_has_booked))
      else
        # @format_booking_params[:end_time] = end_time
        # @format_booking_params[:start_time] = start_time
        if status_charge == Booking::FALSE #booking free
          if @numbers_booked > (Booking::MAXIMUM_BOOKING_FREE - @booking_free)
            @can_booking_free = true
          else
            # Merchant don't charge, Merchant can book free
            # check users has choose accept booking with discount promotion
            if params[:promotion_booking].present?
              @format_booking_params[:check_discount] = true
            else
              @format_booking_params[:check_discount] = false
              # @format_booking_params[:paid_price] = nil
            end
            Booking.transaction do
              @numbers_booked.times do
                # Have booking free
                @can_booking_free = false
                @info_booking = current_user.bookings.create(@format_booking_params)
                @booking_free = @booking_free + Booking::INCREASE_BOOK_FREE
                current_user.booking_free = @booking_free
                current_user.save
              end
              @booking_free = booking_service.get_booking_free_after_book current_user
            end
          end
        else #charge by merchant
          #Merchant charged payment
          if current_user.time_charge > Time.zone.now
            # Merchant charged payment and have time to book free
            @merchant_charged = true
            # check users has choose accept booking with discount promotion
            booking_via_merchant(@format_booking_params, @promotion)
            # reset book free to 0 when users has charged by card
            @booking_free = 0
            @book = booking_service.get_booking_free_after_book current_user
            @billing_card
          elsif current_user.time_charge < Time.zone.now
            @can_booking_free = false
            @book = booking_service.get_booking_free_after_book current_user
            @billing_card
          end
        end
      end
      # send email to merchant has booked
      UserMailer.delay.send_email_to_merchant_books(booking_params, current_user, @info_booking, { zone_name: Time.zone.name }) if @info_booking.present?
    end #end if check type merchant
  end

  def payment_booking_merchant
    @numbers_booked = session[:numbers_booked].to_i
    booking_params = session[:@info_booking]
    token = params[:stripe_token]
    promotion = Promotion.find(params[:promotion_pay_id])
    begin
      Stripe::Charge.create(
        amount: AMOUNT_MERCHANT_PAY,
        currency: CURRENCY_STRIPE_CHARGE,
        card: token,
        description: "#{params[:billing_detail][:email]}"
      )
      rescue Stripe::StripeError => e
        raise e
    end
    binding.pry
    if current_user.user_type == User::USER_TYPE[:merchant]
      current_user.charge_payment = true
      current_user.time_charge = Time.zone.now + 7.minutes
      current_user.booking_free = Booking::MAXIMUM_BOOKING_FREE
      current_user.save
      booking_via_merchant(booking_params, promotion)
      session.delete(:@info_booking)
      session.delete(:numbers_booked)
      session.delete(:promotion_booking)
    end

  end

  # payment with client, from anguar 
  def payment_booking_client
    @numbers_booked = session[:numbers_booked].to_i
    booking_params = session[:@info_booking]
    token = params[:stripe_token]
    amount = (params[:billing_detail][:amount] * 100).round
    promotion = Promotion.find(params[:promotion_pay_id])
    begin
      Stripe::Charge.create(
        amount: amount,
        currency: CURRENCY_STRIPE_CHARGE,
        card: token,
        description: "#{params[:billing_detail][:email]}"
      )
      rescue Stripe::StripeError => e
        raise e
    end
    if current_user.user_type == User::USER_TYPE[:client]
      current_user.charge_payment = true
      current_user.time_charge = Time.zone.now + 7.minutes
      current_user.booking_free = Booking::MAXIMUM_BOOKING_FREE
      current_user.save
      # create booking also check availabel booking
      booking_via_merchant(booking_params, promotion)
      session.delete(:@info_booking)
      session.delete(:numbers_booked)
      session.delete(:promotion_booking)
    end

    render :nothing => true, :status => 200
  end

  def booking_via_merchant format_booking_params, promotion
    binding.pry
    @avaiable_booking = BookingService.calculate_avaiable_booking(format_booking_params, promotion)
    if session[:promotion_booking].present?
      # avaiable promotion booking
      if @avaiable_booking > 0
        # booking with promotion
        Booking.transaction do
          if @numbers_booked <= @avaiable_booking
            #change some params with promotion booking
            format_booking_params[:check_discount] = true
            @numbers_booked.times.each do
              @info_booking = current_user.bookings.create(format_booking_params)
            end
          else
            format_booking_params[:check_discount] = true
            @avaiable_booking.times.each do
              @info_booking = current_user.bookings.create(format_booking_params)
            end
            #change some params with regular booking
            format_booking_params[:check_discount] = false
            # @format_booking_params[:paid_price] = nil
            (@numbers_booked - @avaiable_booking).times.each do
              @info_booking = current_user.bookings.create(format_booking_params)
            end
          end
        end
      else
        format_booking_params[:check_discount] = false
        # @format_booking_params[:paid_price] = nil
        Booking.transaction do
          @numbers_booked.times.each do
            @info_booking = current_user.bookings.create(format_booking_params)
          end
        end
      end
    else
      format_booking_params[:check_discount] = false
      Booking.transaction do
        @numbers_booked.times.each do
          @info_booking = current_user.bookings.create(format_booking_params)
        end
      end
    end
  end

  private
    def booking_params
      params.require(:booking).permit(:book_date, :status, :charge_id, :first_name, :last_name, :email, :phone, :start_time, :end_time, :promotion_id, :check_discount, :promotion_price, :paid_price, :stripe_token, :promotion_booking)
    end

    def booking_service
      @bookings ||= BookingService.new(current_user)
    end


end
