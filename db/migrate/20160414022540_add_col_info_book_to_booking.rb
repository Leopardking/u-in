class AddColInfoBookToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :first_name, :string
    add_column :bookings, :last_name, :string
    add_column :bookings, :email, :string
    add_column :bookings, :phone, :string
  end
end
