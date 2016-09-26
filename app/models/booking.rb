class Booking < ActiveRecord::Base

  ##
  # Relationships
  belongs_to :user
  belongs_to :promotion
  has_many :images, as: :imageable, dependent: :destroy
  # scope
  scope :total_booked_promotion, ->(promotion_id){
    where(promotion_id: promotion_id, check_discount: true)
  }
  scope :regular, ->(promotion_id){
    where(promotion_id: promotion_id, check_discount: false)
  }

  scope :booked_totals_by_date, ->(promotion_id, date){
    where("promotion_id = ? AND book_date = ?", promotion_id, date)
  }

  scope :booked_totals_week_or_month, ->(promotion_id, start_date, end_date){
    where("promotion_id = ? AND book_date >= ? AND book_date <= ?", promotion_id, start_date, end_date)
  }


  scope :booked_totals, ->(promotion_id, start_time, end_time){
    where("promotion_id = ? AND start_time = ? AND end_time = ?", promotion_id, start_time, end_time)
  }

  scope :booked_promotion_totals, ->(promotion_id, start_time, end_time, status){
    where("promotion_id = ? AND start_time = ? AND end_time = ? AND check_discount = ?", promotion_id, start_time, end_time, status)
  }
  validate :email, presence: true
  validate :first_name, presence: true
  validate :last_name, presence: true

  INCREASE_BOOK_FREE = 1
  MAXIMUM_BOOKING_FREE = 3
  FALSE = "false"

  attr_accessor :regular_price
  attr_accessor :discount_price
end
