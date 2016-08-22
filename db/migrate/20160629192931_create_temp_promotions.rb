class CreateTempPromotions < ActiveRecord::Migration
  def change
    create_table :temp_promotions do |t|
      t.string :name
      t.text :description
      t.text :google_map_link
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
      t.date :start_date, index: true
      t.date :end_date, index: true
      t.string :repeat
      t.string :cancellation_minimum
      t.float :cancellation_fee
      t.references :user, index: true
      t.boolean  :same_as_business_address, default: false
      t.boolean  :cancel_status, default: false
      t.integer  :current_rank
      t.time     :start_time
      t.time     :end_time
      t.integer  :frequency, index: true
      t.integer  :end_date_type
      t.text     :days_of_week
      t.integer  :occurrence, index: true
      t.datetime :deleted_at, index: true
      t.text     :bring_item
      t.text     :expect
      t.string   :occurrence_extend
      t.float    :saving_price
      t.integer  :active_times, default: 0

      t.timestamps
    end
  end
end
