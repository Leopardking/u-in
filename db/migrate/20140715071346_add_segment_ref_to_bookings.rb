class AddSegmentRefToBookings < ActiveRecord::Migration
  def change
    add_reference :bookings, :segment, index: true
  end
end
