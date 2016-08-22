class CreatePromotionCategories < ActiveRecord::Migration
  def change
    create_table :promotion_categories do |t|
      t.references :category, index: true
      t.references :promotion, index: true
    end
  end
end
