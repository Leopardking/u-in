class CreateBookingDetails < ActiveRecord::Migration
  def change
    create_table :booking_details do |t|
      t.integer  :booking_criterion
      t.time     :booking_start_time
      t.time     :booking_end_time
      t.time     :blackout_from
      t.time     :blackout_to
      t.string   :booking_duration
      t.integer  :bookings_per_duration
      t.belongs_to :promotion
      t.timestamps
    end
  end
end