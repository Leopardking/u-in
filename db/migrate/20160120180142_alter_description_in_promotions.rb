class AlterDescriptionInPromotions < ActiveRecord::Migration
  def change
    change_column :promotions, :description, :text
  end
end
