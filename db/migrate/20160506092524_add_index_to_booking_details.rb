class AddIndexToBookingDetails < ActiveRecord::Migration
  def change
    add_index :booking_details, :promotion_id
  end
end
