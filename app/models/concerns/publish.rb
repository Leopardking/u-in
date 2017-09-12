module Publish
  extend ActiveSupport::Concern
  included do
    attr_accessor :rank, :current_step
    belongs_to :user
    serialize :days_of_week, Array

    has_many :images, as: :imageable, dependent: :destroy

    has_one :booking_detail, as: :booking_detailable, dependent: :destroy
    has_and_belongs_to_many :categories

    ##
    # Nested models
    accepts_nested_attributes_for :booking_detail
    accepts_nested_attributes_for :categories

    scope :running_promotions, ->(status) { where("cancel_status = ?",status) }

    #validate
    validates :name, presence: true, if: Proc.new{|promo| promo.current_step == promo.steps.first}
    validates_length_of :name, maximum: 60, if: Proc.new{|promo| promo.current_step == promo.steps.first}
    validates :description, presence: true, if: Proc.new{|promo| promo.current_step == promo.steps.first}
    validates_length_of :description, maximum: 2000, if: Proc.new{|promo| promo.current_step == promo.steps.first}
    validates_length_of :expect, maximum: 500, if: Proc.new{|promo| promo.current_step == promo.steps.first}
    validates_length_of :bring_item, maximum: 500, if: Proc.new{|promo| promo.current_step == promo.steps.first}
    validates :street_address_1, presence: true, if: Proc.new{|promo| promo.current_step == promo.steps.second}
    validates :city, presence: true, if: Proc.new{|promo| promo.current_step == promo.steps.second}
    validates :zipcode, presence: true, if: Proc.new{|promo| promo.current_step == promo.steps.second}
    validate :zipcode, :format => {:with => /^\d{1,9}?([-\s])?(\d{1,9})?$/, :message => I18n.t("promotions.validation.zipcode_valid")}, if: Proc.new{|promo| promo.current_step == promo.steps.second}
    validates :phone_number, presence: true, if: Proc.new{|promo| promo.current_step == promo.steps.second}
    validate :phone_number, :format => {:with => /^((\+)?[1-9]{1,12})?([-\s\.])?((\(\d{1,12}\))|\d{1,12})(([-\s\.])?[0-9]{1,12}){1,12}$/, :message => I18n.t("promotions.validation.phone_number_type")}, if: Proc.new{|promo| promo.current_step == promo.steps.second}
    validates :state, presence: true, if: Proc.new{|promo| promo.current_step == promo.steps.second}
    # Second section
    validates_presence_of :price, :discount_price, :discount_percent, if: Proc.new{|promo| promo.current_step == promo.steps.last}
    validate :end_date_cannot_be_the_start_date, if: Proc.new { |promotion| promotion.start_date.present? && promotion.end_date.present?  }
      validate :discount_cannot_be_greater_than_total_value, if: Proc.new{|promo| promo.current_step == promo.steps.last}

    before_save :set_default_date, if: Proc.new{|promotion|  promotion.end_date.blank?}
    before_save :add_default_value, if: Proc.new{|promotion| promotion.days_of_week == ""}
    scope :running_promotions, ->(status) { where("cancel_status = ?",status) }
  end

  def discount
    price - discount_price
  end

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[basic_information add_location add_image assign_catagories add_pricing scheduling_promotion]
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def last_step?
    current_step == steps.last
  end

  def set_default_date
    if self.repeat == "None"
      self.end_date = self.start_date
    else
      self.end_date = nil
    end
  end

  def main_image
    images.where(image_default: true).last
  end

  def active?
    return !self.cancel_status
  end

  def add_default_value
    self.days_of_week = nil
  end

  def end_date_cannot_be_the_start_date
    if start_date > end_date
      errors.add(:errors, I18n.t("promotions.validation.start_end_date"))
    end
  end

  def discount_cannot_be_greater_than_total_value
    if discount_price > price
      errors.add(:errors, I18n.t("promotions.validation.can_be_than_price"))
    end
  end

  #clone folder image
  def get_attachment_folder url
    url = url.gsub(/\w+\/[\w.\-]+$/,"")
  end

  def clone_attachment old_attachment, new_attachment
    url = get_attachment_folder old_attachment.image.path
    new_url = get_attachment_folder new_attachment.image.path
    FileUtils.mkdir_p(new_url) unless File.exists?(new_url)
    FileUtils.copy_entry url, new_url
  end

  ##########

  def get_current_rank
    Promotion.get_current_rank self.as_json(only: [:id, :discount_percent, :created_at], methods: [:discount, :category_ids]).symbolize_keys
  end



  def get_normal_events(schedule, cal_start, cal_end, promotion)
    normal_events = []
    numbers_booking = 0
    date_of_lastest_booking = nil
    #check Maximum Number of Promotion Bookings
    if self.booking_detail.booking_criterion == BOOKING_CRITERION["Total"]
      bookings = self.bookings
    else
      bookings = self.bookings.select{ |book| book.book_date >= cal_start.to_date && book.book_date < cal_end.to_date }
    end
    # to get all number bookings users can book
    numbers_booking = PromotionService.new.get_all_numbers_booking_of_a_day(self)
    generate_number_booking_day = PromotionService.new.general_number_booking_a_day(self, numbers_booking, view_all_day: true)
    total_bookings = generate_number_booking_day[:total_bookings]
    booking_without_promotion_total = generate_number_booking_day[:booking_without_promotion_total]
    # check end_date of a promotion to generate schedule
    end_date = (promotion.end_date? ? promotion.end_date.to_time : cal_end.to_time)
    schedule.occurrences(end_date).each do |date|
      next if (date.to_date < self.start_date || (self.end_date && date.to_date > self.end_date))
      # get status of a promotion at day
      event_status = PromotionService.get_event_statistics_at_date(promotion, bookings, date, view_all_day: true)[:event_status]
      start_date = DateTime.new(date.year, date.month, date.day)
      # check number promotions has booked with discount price
      number_booking = bookings.select{|x| x.book_date == start_date && x.check_discount == true}.size
      date_of_lastest_booking = bookings.sort_by(&:start_time).last.start_time.utc if bookings.present?
      # check number promotions has booked with regular price
      booking_without_promotion = bookings.select{|x| x.check_discount == false &&  x.book_date == start_date}.size
      # check dicount promotions has exist.
      discount_percent = ( number_booking >= self.booking_detail.maximum_bookings ? 0 : self.discount_percent)

      normal_events.push({
        discount_percent: discount_percent,
        name: self.name,
        title: "#{self.discount_percent}% Off #{self.name.titleize}",
        start: Time.zone.local(date.year, date.month, date.day, self.start_time.hour, self.start_time.min, self.start_time.sec),
        end: Time.zone.local(date.year, date.month, date.day, self.end_time.hour, self.end_time.min, self.end_time.sec),
        id: self.id,
        bookings: number_booking,
        date_of_lastest_booking: date_of_lastest_booking,
        total_bookings: total_bookings,
        promotion_price: self.price,
        paid_price: self.saving_price,
        cancel_status: self.cancel_status,
        booking_without_promotion: booking_without_promotion,
        booking_without_promotion_total: booking_without_promotion_total,
        sold_out: I18n.t('models.promotion.segmented_events.promotion_sold_out'),
        booking_regular_price: I18n.t('models.promotion.segmented_events.booking_regular_price'),
        allDay: false,
        allDaySlot: false,
        allDayText: false,
        event_status: event_status
      })
    end
    normal_events_rs = normal_events.flatten.compact
  end
  def number_segments_per_day
    time_booking = (end_time - start_time)/3600
    time_blackout = (booking_detail.blackout_to - booking_detail.blackout_from)/3600 if booking_detail.blackout_from? && booking_detail.blackout_to?
    time_booking = (time_booking - time_blackout) if time_blackout
    (time_booking / booking_detail.booking_duration).to_i
  end


end