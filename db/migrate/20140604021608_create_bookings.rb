class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.references :user, index: true
      t.references :promotion, index: true

      t.timestamps
    end
  end
end
