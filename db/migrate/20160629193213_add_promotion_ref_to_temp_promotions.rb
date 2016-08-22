class AddPromotionRefToTempPromotions < ActiveRecord::Migration
  def change
    add_reference :temp_promotions, :promotion, index: true
  end
end
