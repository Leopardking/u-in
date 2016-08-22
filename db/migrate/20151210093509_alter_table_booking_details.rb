class AlterTableBookingDetails < ActiveRecord::Migration
  def change
  	add_column :booking_details, :maximum_bookings, :integer
  	remove_column :promotions, :booking_available
  end
end
