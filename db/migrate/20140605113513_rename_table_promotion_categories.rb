class RenameTablePromotionCategories < ActiveRecord::Migration
  def change
    rename_table :promotion_categories, :categories_promotions
  end
end
