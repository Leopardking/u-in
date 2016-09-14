class Promotion < ActiveRecord::Base
  include Publish
  paginates_per 10
  acts_as_paranoid
  ##
  # Relationships
  has_many :bookings, dependent: :destroy

  has_many :history_v_moneys
  has_many :other_blackouts
  has_one :temp_promotion, dependent: :destroy
  has_many :reviews
  after_create :clone_data_to_temp_promotion

  class << self
    #sql for to get rank of the promotion
    def current_rank_common category_ids
      result = Promotion.joins(:categories)
        .where("categories.id IN (?)", category_ids)
        .where("end_date IS ? OR end_date >= ?", nil, Time.zone.now)
        .select("promotions.id, promotions.discount_percent, promotions.discount_price, promotions.price, promotions.created_at, categories.id as category_id")
        .map{ |p| {id: p.id, discount_percent: p.discount_percent, discount: p.price - p.discount_price, created_at: p.created_at, category_id: p.category_id}}
    end

    def filter(params)
      promotions = all
      # params[:price_range] e.g -> "20..30"
      if params["price_range"]
        price_range = params["price_range"].to_range
        if price_range.is_a?(String)
          promotions = promotions.where("discount_price > ?", price_range)
        else
          promotions = promotions.where(discount_price: price_range)
        end
      end
      promotions = promotions.where("city LIKE ?", "%#{params['city']}%") if params["city"]
      promotions = promotions.where(state: params["state"]) if params["state"]
      promotions = promotions.where("zipcode LIKE ?", "%#{params['zipcode']}%") if params["zipcode"]
      # params[:category_ids] e.g -> "202, 203"
      promotions = promotions.joins(:categories).where(categories: {id: params["category_ids"].split(",")}).uniq if params["category_ids"].present?
      
      promotions
    end

    def get_total_booking
      select("*, (select COUNT(*) from bookings where bookings.promotion_id=promotions.id) total_booking").order("total_booking DESC")
    end
    
    #get current rank of promotion new
    def get_current_rank promotion
      ranks = []
      sizes = []
      promotion[:id] = promotion[:id].to_i

      raw_promotions_by_category = current_rank_common(promotion[:category_ids]).group_by{ |promo| promo[:category_id] }

      promotion[:category_ids].map(&:to_i).each do |category_id|
        raw_promotions_by_category[category_id] = (raw_promotions_by_category[category_id] || []).reject{ |promo| promo[:id] == promotion[:id] } << promotion
      end

      if raw_promotions_by_category.blank?
        return {
          current_rank: 1,
          total_ranks: 1
        }
      end

      raw_promotions_by_category.each do |category_id, promotions|
        temp_ranks = Rank.add promotions, [:discount, :desc, :float], [ :discount_percent, :desc, :float], [:created_at, :desc, :datetime], :ties => false
        temp_ranks.each do |temp|
          if temp[:id] == promotion[:id]
            ranks << temp[:rank]
            break
          end
        end
        sizes << temp_ranks.size
      end

      {
        current_rank: (ranks.sum / ranks.size.to_f).round,
        total_ranks: sizes.max
      }
    end

    def generate_normal_events(promotion_id, cal_start, cal_end, inactive_promotion = false)
      events = []
      promotions = Promotion.where("id IN (?)", promotion_id).includes(:bookings, :booking_detail, :other_blackouts)
      return events if promotions.empty?
      promotions.each do |promo|
        schedule = PromotionService.new.general_repeated_events_by_ice_cube promo,cal_start
        # get all events of inactive promotions
        if inactive_promotion
          events.push(PromotionService.new.get_events_inactive_promotion(schedule, cal_start, cal_end, promo))
        else
          # get all events based on the generated schedules
          events.push(promo.get_normal_events(schedule, cal_start, cal_end, promo))
        end
      end
      events.flatten.compact
    end
  end

  # Generating events based on the segments
  def self.generate_segments_events(promotion_id, cal_start, cal_end, new_calendar=nil)
    events = []
    promotions = Promotion.where("id IN (?)", promotion_id)
    return events if promotions.empty?
    promotions.each do |promo|
      schedule = PromotionService.new.general_repeated_events_by_ice_cube promo,cal_start
      # get all events based on the generated schedules
      events.push(promo.get_segmented_events(schedule, cal_start, cal_end,promo,new_calendar))
    end
    events.flatten.compact
  end

  # Generates events based on the generated schedules of a day or a week
  def get_segmented_events(schedule, cal_start, cal_end, promotion, new_calendar=nil)
    scheduled_events = []
    date_of_lastest_booking = nil
    booking_promotion_avaiable = 0
    all_bookings = self.bookings
    date_of_lastest_booking = all_bookings.sort_by(&:start_time).last.try(:start_time)
    # get list all number booking of a promotion
    bookings = self.bookings.select{ |book| book.book_date >= cal_start.to_date && book.book_date < cal_end.to_date }
    # to get all number bookings users can book
    numbers_booking = PromotionService.new.get_all_numbers_booking_of_a_day(self)
    maximum_bookings = self.booking_detail.maximum_bookings
    bookings_per_duration = self.booking_detail.bookings_per_duration
    end_date = cal_end.to_time

    #number booking promotion per day
    generate_number_booking_day = PromotionService.new.general_number_booking_a_day(self, numbers_booking)
    booking_without_promotion_total = generate_number_booking_day[:booking_without_promotion_total]
    total_bookings = generate_number_booking_day[:total_bookings]

    schedule.occurrences(end_date).each do |date|
      segments = get_segments
      segments.each do |start_t, end_t|
        start_time = Time.zone.local(date.year, date.month, date.day, start_t.hour, start_t.min, start_t.sec)
        end_time = Time.zone.local(date.year, date.month, date.day, end_t.hour, end_t.min, end_t.sec)

        event_statistic = PromotionService.get_event_statistics_at_date(promotion, bookings, start_time)
        event_status = event_statistic[:event_status]
        available_bookings = self.booking_detail.maximum_bookings - event_statistic[:number_promotion_booked_at_this_period] + event_statistic[:number_promotion_booked_at_this_moment]
        available_books_at_this_moment = [self.booking_detail.bookings_per_duration - event_statistic[:number_booked_at_this_moment] + event_statistic[:number_regular_booked_at_this_moment], booking_without_promotion_total].min
        #number booking promotions with regular price
        number_booking = bookings.select{|x| x.start_time == start_time && x.check_discount == true}.size
        #number booking promotions with discount price
        booking_without_promotion = bookings.select{|x| x.check_discount == false &&  x.start_time == start_time}.size

        number_bookings_in_current_period = all_bookings.select{ |book| book.start_time >= start_time && book.end_time <= end_time }.size

        discount_percent = ( number_booking == total_bookings ? 0 : self.discount_percent )

        # check number booking promotion avaiable
        if event_statistic[:event_status] == "promotion_available"
          booking_promotion_avaiable = [available_bookings, total_bookings].min - number_booking
        end
        if new_calendar == "true"
          scheduled_events.push({
            discount_percent: discount_percent,
            name: self.name,
            title: "#{self.discount_percent}% Off",
            start: start_time,
            end: end_time,
            id: self.id,
            bookings: number_booking,
            date_of_lastest_booking: date_of_lastest_booking,
            total_bookings: [available_bookings, total_bookings].min,
            promotion_price: self.price,
            paid_price: self.saving_price,
            cancel_status: self.cancel_status,
            number_bookings_in_current_period: number_bookings_in_current_period,
            booking_without_promotion: booking_without_promotion,
            booking_without_promotion_total: event_status == 'regular_available' ? available_books_at_this_moment : booking_without_promotion_total,
            sold_out: I18n.t('models.promotion.segmented_events.promotion_sold_out'),
            booking_regular_price: I18n.t('models.promotion.segmented_events.booking_regular_price'),
            allDay: false,
            event_status: event_status,
            booking_promotion_avaiable: booking_promotion_avaiable
          })
        else
          scheduled_events.push({
            discount_percent: discount_percent,
            name: self.name,
            title: "#{self.discount_percent}% Off #{self.name.titleize}",
            start: start_time,
            end: end_time,
            id: self.id,
            bookings: number_booking,
            date_of_lastest_booking: date_of_lastest_booking,
            total_bookings: [available_bookings, total_bookings].min,
            promotion_price: self.price,
            paid_price: self.saving_price,
            cancel_status: self.cancel_status,
            number_bookings_in_current_period: number_bookings_in_current_period,
            booking_without_promotion: booking_without_promotion,
            booking_without_promotion_total: event_status == 'regular_available' ? available_books_at_this_moment : booking_without_promotion_total,
            sold_out: I18n.t('models.promotion.segmented_events.promotion_sold_out'),
            booking_regular_price: I18n.t('models.promotion.segmented_events.booking_regular_price'),
            allDay: false,
            event_status: event_status,
            booking_promotion_avaiable: booking_promotion_avaiable
          })
        end
      end
      # Get the blackout time slots
      if self.booking_detail.blackout_from.present?
        scheduled_events.push({
          title: I18n.t("models.promotion.segmented_events.title"),
          start: Time.zone.local(date.year, date.month, date.day, self.booking_detail.blackout_from.hour, self.booking_detail.blackout_from.min, self.booking_detail.blackout_from.sec),
          end: Time.zone.local(date.year, date.month, date.day, self.booking_detail.blackout_to.hour, self.booking_detail.blackout_to.min, self.booking_detail.blackout_to.sec),
          id: self.id,
          blackout: true,
          custom_blackout: false,
          allDay: false
        })
      end
      # get other blackout of a promotion
      scheduled_events.push(self.get_other_blackout_events(date))
    end
    scheduled_events.compact
  end

  # Generates events for other blackouts
  def get_other_blackout_events(cal_date)
      blackouts = OtherBlackout.get_other_black_out_for_events(cal_date.to_date.to_s)
      if blackouts.present?
        blackout_events = []
        blackouts.each do |ob|
          blackout_events.push({
            title: "This slot is blocked",
            start: ob.blackout_from,
            end: ob.blackout_to,
            id: id,
            blackout_id: ob.id,
            blackout: true,
            custom_blackout: true,
            allDay: false
        })
        end
        blackout_events
    end
  end

  def get_segments
    time_intervals = []
    interval_start_time = self.start_time
    begin

      interval_end_time = interval_start_time + booking_detail.booking_duration.to_f.hours
      if self.booking_detail.blackout_from.present?
        if (interval_end_time > self.booking_detail.blackout_from && interval_end_time <= self.booking_detail.blackout_to) || (interval_start_time >= self.booking_detail.blackout_from && interval_start_time < self.booking_detail.blackout_to)
          interval_start_time = self.booking_detail.blackout_to
        else
          time_intervals << [interval_start_time, interval_end_time]
          interval_start_time = interval_end_time
        end
      else
        time_intervals << [interval_start_time, interval_end_time]
        interval_start_time = interval_end_time
      end
    end while interval_start_time + booking_detail.booking_duration.to_f.hours <= self.end_time
    time_intervals
  end

  # def number_segments_per_day
  #   time_booking = (end_time - start_time)/3600
  #   time_blackout = (booking_detail.blackout_to - booking_detail.blackout_from)/3600 if booking_detail.blackout_from? && booking_detail.blackout_to?
  #   time_booking = (time_booking - time_blackout) if time_blackout
  #   (time_booking / booking_detail.booking_duration).to_i
  # end


  def clone_data_to_temp_promotion
    Promotion.transaction do
      temp_pro = self.create_temp_promotion({
        name: self.name,
        description: self.description,
        google_map_link: self.google_map_link,
        street_address_1: self.street_address_1,
        street_address_2: self.street_address_2,
        city: self.city,
        state: self.state,
        zipcode: self.zipcode,
        phone_number: self.phone_number,
        youtube_video: self.youtube_video,
        price: self.price,
        discount_percent: self.discount_percent,
        discount_price: self.discount_price,
        start_date: self.start_date,
        end_date: self.end_date,
        repeat: self.repeat,
        cancellation_minimum: self.cancellation_minimum,
        cancellation_fee: self.cancellation_fee,
        user_id: self.user_id,
        same_as_business_address: self.same_as_business_address,
        cancel_status: self.cancel_status,
        current_rank: self.current_rank,
        start_time: self.start_time,
        end_time: self.end_time,
        frequency: self.frequency,
        end_date_type: self.end_date_type,
        days_of_week: self.days_of_week,
        occurrence: self.occurrence,
        deleted_at: self.deleted_at,
        bring_item: self.bring_item,
        expect: self.expect,
        occurrence_extend: self.occurrence_extend,
        saving_price: self.saving_price,
        active_times: self.active_times,
        created_at: self.created_at,
        updated_at: self.updated_at,
        promotion_id: self.id
      })
      image_temps = self.images.each do |image_temp|
        new_attachment = temp_pro.images.create!({
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
          imageable_id: temp_pro.id,
          imageable_type: "TempPromotion"
        })
        clone_attachment(image_temp, new_attachment)
      end
      booking_detail_temps = self.booking_detail
      temp_pro.create_booking_detail({
        booking_criterion: booking_detail_temps.booking_criterion,
        booking_start_time: booking_detail_temps.booking_start_time,
        booking_end_time: booking_detail_temps.booking_end_time,
        blackout_from: booking_detail_temps.blackout_from,
        blackout_to: booking_detail_temps.blackout_to,
        booking_duration: booking_detail_temps.booking_duration,
        bookings_per_duration: booking_detail_temps.bookings_per_duration,
        created_at: booking_detail_temps.created_at,
        updated_at: booking_detail_temps.updated_at,
        maximum_bookings: booking_detail_temps.maximum_bookings,
        booking_detailable_id: temp_pro.id,
        booking_detailable_type: "TempPromotion"
      })
      temp_pro.categories = self.categories
    end

  end

end
