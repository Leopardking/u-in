class OtherBlackout < ActiveRecord::Base

  belongs_to :promotion

  validates_presence_of :blackout_from, :blackout_to
  validate :validate_time

  #scope
  scope :get_other_black_out_for_events, ->(cal_date) { where("Date(blackout_from) = ?", cal_date)}

  private
  def validate_time
    self.errors.add(:base, I18n.t('other_blackout.errors.messages.in_the_past')) if blackout_from < Time.zone.now
    self.errors.add(:blackout_from, I18n.t('other_blackout.errors.messages.form_greater_than_to')) if (self.blackout_from > self.blackout_to)
    self.errors.add(:base, I18n.t('other_blackout.errors.messages.has_booking')) if Booking.exists?(start_time: blackout_from..blackout_to, promotion: promotion) || Booking.exists?(end_time: blackout_from..blackout_to, promotion: promotion)
  end
end
