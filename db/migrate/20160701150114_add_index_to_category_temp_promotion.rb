class AddIndexToCategoryTempPromotion < ActiveRecord::Migration
  def change
    add_index :categories_temp_promotions, :category_id
    add_index :categories_temp_promotions, :temp_promotion_id
  end
end
