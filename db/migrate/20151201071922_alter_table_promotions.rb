class AlterTablePromotions < ActiveRecord::Migration
  def change
  	change_column :promotions, :repeat, :string
  	change_column :promotions, :cancellation_minimum, :string
  	add_column :promotions, :start_time, :time
	  add_column :promotions, :end_time, :time
    add_column :promotions, :frequency, :integer
  	add_column :promotions, :end_date_type, :integer
  	add_column :promotions, :days_of_week, :text
  	add_column :promotions, :occurrence, :integer
  end
end