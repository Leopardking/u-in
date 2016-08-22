class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.integer :promotion_id, index: true
      t.time :start_time
      t.time :end_time
      t.integer :bookings_count
      t.boolean :is_blackout
      t.integer :max_bookings
      t.timestamps
    end
  end
end
