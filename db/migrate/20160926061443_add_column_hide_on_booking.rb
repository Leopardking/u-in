class AddColumnHideOnBooking < ActiveRecord::Migration
  def change
  	add_column :bookings, :listing_show, :boolean, default: true
  end
end
