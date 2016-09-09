class BookingService < BaseService
  def check_status_charge user, status_charge
    if user.user_type == User::USER_TYPE[:merchant]
      if user.time_charge.nil? || user.time_charge < Time.zone.now
        user.charge_payment = false
        user.save
        status_charge = Booking::FALSE
      else
        status_charge
      end
    end
    status_charge
  end

  def get_booking_free_after_book user
    Booking::MAXIMUM_BOOKING_FREE - user.booking_free
  end

  def self.calculate_avaiable_booking params, promotion
    binding.pry
    totals_promotion_booking = PromotionService.number_avaiable_promotion_booking(promotion)
    case promotion.booking_detail.booking_criterion
      when BOOKING_CRITERION["Duration"]
        # check number booking of users has exceed avaiable booking
        start_time = params[:start_time].present? ? params[:start_time].to_time.strftime("%Y-%m-%d %H:%M:%S") : nil
        end_time = params[:end_time].present? ? params[:end_time].to_time.strftime("%Y-%m-%d %H:%M:%S") : nil
        totals_has_booked = Booking.booked_totals(params[:promotion_id], start_time, end_time).size
        @avaiable_booking = totals_promotion_booking - totals_has_booked
      when BOOKING_CRITERION["Day"]
        # Count number of promotion booked in the "date"
        # Period in this case is 'day'
        date = params[:start_time].present? ? params[:start_time].to_time.strftime("%Y-%m-%d") : nil
        totals_has_booked = Booking.booked_totals_by_date(params[:promotion_id], date).size
        @avaiable_booking = totals_promotion_booking - totals_has_booked
      when BOOKING_CRITERION["Week"]
        # Count number of promotion booked in the week of the "date"
        # Period in this case is 'week', first day of week is Sunday which corresponding to fullcalendar in client side
        date = params[:start_time].present? ? params[:start_time].to_time.strftime("%Y-%m-%d") : nil
        start_week = date.to_date.beginning_of_week(:sunday).to_time.strftime("%Y-%m-%d")
        end_week = date.to_date.end_of_week(:sunday).to_time.strftime("%Y-%m-%d")
        totals_has_booked = Booking.booked_totals_week_or_month(params[:promotion_id], start_week, end_week).size
        @avaiable_booking = totals_promotion_booking - totals_has_booked
      when BOOKING_CRITERION["Month"]
        # Count number of promotion booked in the month of the "date"
        # Period in this case is 'month'
        date = params[:start_time].present? ? params[:start_time].to_time.strftime("%Y-%m-%d") : nil
        start_month = date.to_date.beginning_of_month.to_time.strftime("%Y-%m-%d")
        end_month = date.to_date.end_of_month.to_time.strftime("%Y-%m-%d")
        totals_has_booked = Booking.booked_totals_week_or_month(params[:promotion_id], start_month, end_month).size
        @avaiable_booking = totals_promotion_booking - totals_has_booked
      when BOOKING_CRITERION["Total"]
        # Count number of all promotions booked
        # Period in this case is 'all'
        totals_has_booked = Booking.where("promotion_id = ?", params[:promotion_id]).size
        @avaiable_booking = totals_promotion_booking - totals_has_booked
      end
  end
end