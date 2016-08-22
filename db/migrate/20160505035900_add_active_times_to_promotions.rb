class AddActiveTimesToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :active_times, :integer, default: 0
  end
end
