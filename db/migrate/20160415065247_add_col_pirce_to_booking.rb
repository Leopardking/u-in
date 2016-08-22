class AddColPirceToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :promotion_price, :decimal
    add_column :bookings, :paid_price, :decimal
  end
end
