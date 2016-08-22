class BookingDetail < ActiveRecord::Base
  belongs_to :booking_detailable, polymorphic: true

  validates_presence_of :booking_criterion, :booking_duration,
						:bookings_per_duration, :maximum_bookings
  # validate :validate_time

  private
  def validate_time
  	if (self.blackout_from > self.blackout_to)
  	  self.errors.add(:blackout_from, "must be before Blackout to")
  	elsif self.blackout_to < self.blackout_from
  	  self.errors.add(:blackout_to, "must be after Blackout from")
  	end
  end
end
