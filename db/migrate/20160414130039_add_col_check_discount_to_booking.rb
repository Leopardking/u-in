class AddColCheckDiscountToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :check_discount, :boolean, default: false
  end
end
