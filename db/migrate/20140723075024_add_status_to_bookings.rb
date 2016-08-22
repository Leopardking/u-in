class AddStatusToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :status, :boolean, :default => true
  end
end
