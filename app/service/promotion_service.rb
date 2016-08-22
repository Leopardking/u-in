class PromotionService < BaseService

  class << self
    def get_event_statistics_at_date(promotion, bookings, date, options={})
      maximum_promotion_bookings = promotion.booking_detail.maximum_bookings
      maximum_bookings = promotion.booking_detail.bookings_per_duration

      if options[:view_all_day] # view by day
        number_booked_at_this_moment = bookings.select{ |x| x.book_date == date.to_date }.size
        number_promotion_booked_at_this_moment = bookings.select{ |x| x.book_date == date.to_date && x.check_discount }.size
        maximum_bookings = maximum_bookings * promotion.number_segments_per_day # Number of total promotion + regular can be sold in one day
      else # view by segment
        number_booked_at_this_moment = bookings.select{ |x| x.start_time == date }.size
        number_promotion_booked_at_this_moment = bookings.select{ |x| x.start_time == date && x.check_discount }.size
      end
      case promotion.booking_detail.booking_criterion
      when BOOKING_CRITERION["Duration"]
        maximum_promotion_bookings = maximum_promotion_bookings * promotion.number_segments_per_day if options[:view_all_day]

        # Period in this case is 'segment'
        if options[:view_all_day]
          number_promotion_booked_at_this_period = bookings.select{ |x| x.book_date == date.to_date && x.check_discount }.size
        else
          number_promotion_booked_at_this_period = bookings.select{ |x| x.start_time == date && x.check_discount }.size
        end
      when BOOKING_CRITERION["Day"]
        # Count number of promotion booked in the "date"
        # Period in this case is 'day'
        number_promotion_booked_at_this_period = bookings.select{ |x| x.book_date == date.to_date && x.check_discount }.size
      when BOOKING_CRITERION["Week"]
        # Count number of promotion booked in the week of the "date"
        # Period in this case is 'week', first day of week is Sunday which corresponding to fullcalendar in client side
        start_week = date.to_date.beginning_of_week(:sunday)
        end_week = date.to_date.end_of_week(:sunday)
        number_promotion_booked_at_this_period = bookings.select{ |x|  x.check_discount && x.book_date >= start_week && x.book_date <= end_week }.size
      when BOOKING_CRITERION["Month"]
        # Count number of promotion booked in the month of the "date"
        # Period in this case is 'month'
        start_month = date.to_date.beginning_of_month
        end_month = date.to_date.end_of_month
        number_promotion_booked_at_this_period = bookings.select{ |x|  x.check_discount && x.book_date >= start_month && x.book_date <= end_month }.size
      when BOOKING_CRITERION["Total"]
        # Count number of all promotions booked
        # Period in this case is 'all'
        number_promotion_booked_at_this_period = bookings.select{ |x|  x.check_discount }.size
      end

      event_status = if number_booked_at_this_moment < maximum_bookings
        if number_promotion_booked_at_this_period < maximum_promotion_bookings
          'promotion_available' # Promotion still has discount slots
        else
          'regular_available' # Promotion has only regular slots
        end
      else
        'sold_out' # Promotion is sold out (has no slot)
      end

      {
        event_status: event_status,
        number_promotion_booked_at_this_period: number_promotion_booked_at_this_period,
        number_booked_at_this_moment: number_booked_at_this_moment,
        number_promotion_booked_at_this_moment: number_promotion_booked_at_this_moment,
        number_regular_booked_at_this_moment: number_booked_at_this_moment - number_promotion_booked_at_this_moment
      }
    end

    def number_avaiable_promotion_booking promotion
      maximum_bookings = promotion.booking_detail.maximum_bookings
      bookings_per_duration = promotion.booking_detail.bookings_per_duration
      booking_promotion_avaiable = (maximum_bookings < bookings_per_duration) ? maximum_bookings : bookings_per_duration
    end
  end

  def publish_promotion temp_promotion
    TempPromotion.transaction do
      temp_promotion.user.promotions.each do |promo|
        promo.update_attributes(cancel_status: true, active_times: promo.active_times + 1)
      end
      temp_pro = temp_promotion.promotion.update_attributes({
        name: temp_promotion.name,
        description: temp_promotion.description,
        google_map_link: temp_promotion.google_map_link,
        street_address_1: temp_promotion.street_address_1,
        street_address_2: temp_promotion.street_address_2,
        city: temp_promotion.city,
        state: temp_promotion.state,
        zipcode: temp_promotion.zipcode,
        phone_number: temp_promotion.phone_number,
        youtube_video: temp_promotion.youtube_video,
        price: temp_promotion.price,
        discount_percent: temp_promotion.discount_percent,
        discount_price: temp_promotion.discount_price,
        start_date: temp_promotion.start_date,
        end_date: temp_promotion.end_date,
        repeat: temp_promotion.repeat,
        cancellation_minimum: temp_promotion.cancellation_minimum,
        cancellation_fee: temp_promotion.cancellation_fee,
        user_id: temp_promotion.user_id,
        same_as_business_address: temp_promotion.same_as_business_address,
        cancel_status: false,
        current_rank: temp_promotion.current_rank,
        start_time: temp_promotion.start_time,
        end_time: temp_promotion.end_time,
        frequency: temp_promotion.frequency,
        end_date_type: temp_promotion.end_date_type,
        days_of_week: temp_promotion.days_of_week,
        occurrence: temp_promotion.occurrence,
        deleted_at: temp_promotion.deleted_at,
        bring_item: temp_promotion.bring_item,
        expect: temp_promotion.expect,
        occurrence_extend: temp_promotion.occurrence_extend,
        saving_price: temp_promotion.saving_price,
        active_times: temp_promotion.active_times,
        created_at: temp_promotion.created_at,
        updated_at: temp_promotion.updated_at
      })
      temp_promotion.promotion.images.destroy_all
      image_temps = temp_promotion.images.each do |image_temp|
        new_attachment = temp_promotion.promotion.images.create!({
          image_file_name: image_temp.image_file_name,
          image_content_type: image_temp.image_content_type,
          image_file_size: image_temp.image_file_size,
          image_updated_at: image_temp.image_updated_at,
          created_at: image_temp.created_at,
          updated_at: image_temp.updated_at,
          description_image: image_temp.description_image,
          image_no: image_temp.image_no,
          image_default: image_temp.image_default,
          crop_x: image_temp.crop_x,
          crop_y: image_temp.crop_y,
          crop_w: image_temp.crop_w,
          crop_h: image_temp.crop_h,
          user_id: image_temp.user_id,
          avatar_file_name: image_temp.avatar_file_name,
          avatar_content_type: image_temp.avatar_content_type,
          avatar_file_size: image_temp.avatar_file_size,
          avatar_updated_at: image_temp.avatar_updated_at,
          using_image: image_temp.using_image,
          imageable_id: temp_promotion.id,
          imageable_type: "Promotion"
        })
        temp_promotion.clone_attachment(image_temp, new_attachment)
      end

      booking_detail_temps = temp_promotion.booking_detail
      temp_promotion.promotion.booking_detail.update_attributes({
        booking_criterion: booking_detail_temps.booking_criterion,
        booking_start_time: booking_detail_temps.booking_start_time,
        booking_end_time: booking_detail_temps.booking_end_time,
        blackout_from: booking_detail_temps.blackout_from,
        blackout_to: booking_detail_temps.blackout_to,
        booking_duration: booking_detail_temps.booking_duration,
        bookings_per_duration: booking_detail_temps.bookings_per_duration,
        created_at: booking_detail_temps.created_at,
        updated_at: booking_detail_temps.updated_at,
        maximum_bookings: booking_detail_temps.maximum_bookings
      })
      temp_promotion.promotion.categories = temp_promotion.categories
    end
  end

  def calculate_time_booking(promotion)
    time_booking = (promotion.end_time - promotion.start_time)/3600
    booking_detail = promotion.booking_detail
    time_blackout = (booking_detail.blackout_to - booking_detail.blackout_from)/3600 if booking_detail.blackout_from? && booking_detail.blackout_to?
    time_booking = (time_booking - time_blackout) if time_blackout.present?
    result = {
      time_booking: time_booking,
      booking_detail: booking_detail
    }
  end

  def general_repeated_events_by_ice_cube promo,cal_start
    starts_at = promo.start_date
    schedule = IceCube::Schedule.new(starts_at)
    # check repeat at step6 of promotion to add to IceCube library
    case promo.repeat
    when 'None'
      schedule.add_recurrence_time(starts_at)
    when 'Daily'
      schedule.add_recurrence_rule IceCube::Rule.daily(promo.frequency)
    when 'Weekly'
      noEmptyDayOfWeek = promo.days_of_week.reject { |c| c.empty? }
      days = noEmptyDayOfWeek.map {|d| d.downcase.to_sym }
      schedule.add_recurrence_rule IceCube::Rule.weekly(promo.frequency).day(*days)
    when 'Monthly'
      if promo.occurrence == 0
        schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_month(promo.occurrence_extend.to_i)
      else
        days = promo.days_of_week.map { |d| d.downcase.to_sym }
        occurrence_count = Array.new.push(promo.occurrence.to_i == 5 ? (-1) : promo.occurrence.to_i)
      days_json = {}
      days.each{|day| days_json[day] = occurrence_count}
      schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_week(days_json)
      end
    end
    schedule
  end

  # calculate number can booking a day
  def get_all_numbers_booking_of_a_day promotion
    cal_time = calculate_time_booking promotion
    time_booking = cal_time[:time_booking]
    booking_detail = cal_time[:booking_detail]
    numbers_booking = (time_booking/booking_detail.booking_duration.to_i).to_i * booking_detail.bookings_per_duration if booking_detail.booking_duration? && booking_detail.bookings_per_duration?
  end

  def show_display_discount_for_a_promotion(promotion,scheduled_events, start_time_promotion, numbers_booking_promotion,booking_without_promotion=nil)
    scheduled_events_rs = []
    scheduled_events.each do |event|
      # check discount for a day
      if event.present?
        next if event.class == Array #inoge if event has array
        if promotion.booking_detail.booking_criterion == BOOKING_CRITERION["Day"] || promotion.booking_detail.booking_criterion == BOOKING_CRITERION["Week"]
          event[:discount_percent] = 0 if promotion.booking_detail.booking_criterion == BOOKING_CRITERION["Day"]
          if event[:start] == start_time_promotion
            event[:bookings] = numbers_booking_promotion
            event[:booking_without_promotion] = booking_without_promotion if booking_without_promotion.present?
          else
            if promotion.booking_detail.booking_criterion == BOOKING_CRITERION["Day"]
              event[:total_bookings] = (booking_without_promotion.present? ? numbers_booking_promotion - booking_without_promotion : numbers_booking_promotion)  if event[:start].strftime("%m/%d/%Y") == start_time_promotion.strftime("%m/%d/%Y") #only check with a day and ignore with case a week
            else
              event[:total_bookings] = numbers_booking_promotion
            end
          end
        elsif promotion.booking_detail.booking_criterion == BOOKING_CRITERION["Duration"]
          event[:booking_without_promotion] = booking_without_promotion if booking_without_promotion.present? && (promotion.booking_detail.maximum_bookings >= promotion.booking_detail.bookings_per_duration)
        end
        scheduled_events_rs.push(event)
      end
    end
  end

  def number_of_promotion_booked(promotion_id, current_user_id)
    Booking.total_booked_promotion(promotion_id).count
  end

  def number_of_regular_bookings(promotion, current_user_id)
    normal_events = []
    if promotion.end_date?
      numbers_booking = PromotionService.new.get_all_numbers_booking_of_a_day(promotion)
      schedule = general_repeated_events_by_ice_cube promotion,promotion.start_date
      schedule.occurrences(promotion.end_date.to_time).each do |date|
        generate_number_booking_day = general_number_booking_a_day(promotion, numbers_booking, view_all_day: true)
        # calculator regular space of a promotion
        regular_space =  generate_number_booking_day[:booking_without_promotion_total]
        normal_events.push(regular_space)
      end
      unless normal_events.sum.zero?
        normal_events.sum - Booking.regular(promotion.id).size
      else
        normal_events.sum
      end
    else
      normal_events.push(25) # with case no end_date of a promotion
    end
  end

  def show_number_promotion_of_a_active(promotion, start_date, end_date, current_user_id)
    # promotion = promotion.promotion if promotion.is_a?(TempPromotion)
    if current_user_id.nil?
      promotion = promotion
    else
      promotion = promotion.promotion unless current_user_id == promotion.user_id
    end
    maximum_bookings = promotion.booking_detail.maximum_bookings
    bookings_per_duration = promotion.booking_detail.bookings_per_duration
    booking_criterion = promotion.booking_detail.booking_criterion
    event_promotions = Promotion.generate_normal_events(promotion.id, start_date, end_date).size
    time_numbers_booking = calculate_time_booking(promotion)
    if booking_criterion == BOOKING_CRITERION["Duration"]
      event_promotions*maximum_bookings*time_numbers_booking[:time_booking]
    elsif booking_criterion == BOOKING_CRITERION["Day"]
      event_promotions*maximum_bookings
    elsif booking_criterion == BOOKING_CRITERION["Week"]
      ((end_date.strftime("%U").to_i - start_date.strftime("%U").to_i) + 1 ) * maximum_bookings
    elsif booking_criterion == BOOKING_CRITERION["Month"]
      ((end_date.strftime("%m").to_i - start_date.strftime("%m").to_i) + 1) * maximum_bookings
    elsif booking_criterion == BOOKING_CRITERION["Total"]
      maximum_bookings
    end
  end

  def result_space_promotion(promotion, start_date, end_date, promotion_id, current_user_id)
    if current_user_id.nil?
      promotion = promotion
    else
      promotion = promotion.promotion unless current_user_id == promotion.user_id
    end
    if show_number_promotion_of_a_active(promotion, start_date, end_date, current_user_id)-number_of_promotion_booked(promotion_id, current_user_id) > 0
      space = show_number_promotion_of_a_active(promotion, start_date, end_date, current_user_id)-number_of_promotion_booked(promotion_id, current_user_id)
      check_discount = true
    else
      space = number_of_regular_bookings(promotion, current_user_id)
      check_discount = false
    end
    result = {
      space: space,
      check_discount: check_discount
    }
  end

  def show_space(promotion, start_date, end_date, promotion_id, current_user_id)
    show = result_space_promotion(promotion, start_date, end_date, promotion_id, current_user_id)

    if show[:space] < 25
      show[:space]
    else
      "25+"
    end
  end

  def show_discount_percent(promotion, start_date, end_date,promotion_id, current_user_id)
    if current_user_id.nil?
      promotion
    else
      promotion = promotion.promotion unless current_user_id == promotion.user_id
    end
    show = result_space_promotion(promotion, start_date, end_date,promotion_id, current_user_id)
    if show[:check_discount]
      promotion.discount_percent.round(2)
    else
      0
    end
  end

  def show_discount_price(promotion, start_date, end_date, promotion_id, current_user_id)
      show = result_space_promotion(promotion, start_date, end_date,promotion_id, current_user_id)
      if show[:check_discount]
        promotion.discount_price.round(2)
      else
        promotion.price
      end
  end

  def show_saving_price(promotion, start_date, end_date,promotion_id, current_user_id)
      show = result_space_promotion(promotion, start_date, end_date, promotion_id, current_user_id)
      if show[:check_discount]
        promotion.saving_price
      else
        nil
      end
  end

  def general_number_booking_a_day(promotion, numbers_booking, options={})
    # Maximum Number of Promotion Bookings follow per duration
    if promotion.booking_detail.booking_criterion == BOOKING_CRITERION["Duration"]
      total_bookings = promotion.booking_detail.maximum_bookings
      booking_without_promotion_total = promotion.booking_detail.bookings_per_duration - promotion.booking_detail.maximum_bookings
      if options[:view_all_day]
        total_bookings = total_bookings * promotion.number_segments_per_day
        booking_without_promotion_total = booking_without_promotion_total * promotion.number_segments_per_day
      end
    else
      total_regular_bookings = numbers_booking - promotion.booking_detail.maximum_bookings
      if options[:view_all_day]
        total_bookings = promotion.booking_detail.maximum_bookings
        booking_without_promotion_total = total_regular_bookings
      else
        total_bookings = [promotion.booking_detail.maximum_bookings,  promotion.booking_detail.bookings_per_duration].min
        booking_without_promotion_total = [total_regular_bookings, promotion.booking_detail.bookings_per_duration].min
      end
    end
    result = {
      total_bookings: total_bookings,
      booking_without_promotion_total: booking_without_promotion_total
    }
  end

  #generates events inactive promotion from start-date to end-date
  def get_events_inactive_promotion(schedule, cal_start, cal_end, promotion)
    normal_events = []
    maximum_bookings = promotion.booking_detail.bookings_per_duration * promotion.number_segments_per_day
    end_date = (promotion.end_date? ? promotion.end_date.to_time : cal_end.to_time)
    schedule.occurrences(end_date).each do |date|
      number_booking_this_date = promotion.bookings.select{ |b| b.book_date == date.to_date }.size
      normal_events.push({
        title: "#{promotion.discount_percent}% Off #{promotion.name.titleize}\n \n #{number_booking_this_date} of #{maximum_bookings} Booked",
        start: Time.zone.local(date.year, date.month, date.day, promotion.start_time.hour, promotion.start_time.min, promotion.start_time.sec),
        end: Time.zone.local(date.year, date.month, date.day, promotion.end_time.hour, promotion.end_time.min, promotion.end_time.sec),
        booked_promotion: "#{number_booking_this_date} of #{maximum_bookings}"
      })
    end
    normal_events.flatten.compact
  end
end
