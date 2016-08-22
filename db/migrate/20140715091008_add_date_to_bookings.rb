class AddDateToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :book_date, :date
  end
end
