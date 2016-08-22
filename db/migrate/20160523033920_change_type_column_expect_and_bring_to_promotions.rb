class ChangeTypeColumnExpectAndBringToPromotions < ActiveRecord::Migration
  def change
    change_column :promotions, :expect, :text
    change_column :promotions, :bring_item, :text
  end
end
