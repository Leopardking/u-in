class ChangeBookingDurationFromStringToDecimalFromBookingDetails < ActiveRecord::Migration
  def change
    change_column :booking_details, :booking_duration, :decimal
  end
end
