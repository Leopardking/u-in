class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :name
      t.string :description
      t.string :google_map_link
      t.string :street_address_1
      t.string :street_address_2
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :phone_number
      t.string :youtube_video
      t.float :price
      t.float :discount_percent
      t.float :discount_price
      t.string :start_date
      t.date :end_date
      t.boolean :repeat
      t.integer :booking_available
      t.integer :cancellation_minimum
      t.float :cancellation_fee
      t.references :user, index: true

      t.timestamps
    end
  end
end
