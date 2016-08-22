class AddIndexToPromotions < ActiveRecord::Migration
  def change
  	add_index :promotions, :start_date
  	add_index :promotions, :end_date
  	add_index :promotions, :frequency
  	add_index :promotions, :occurrence
  end
end