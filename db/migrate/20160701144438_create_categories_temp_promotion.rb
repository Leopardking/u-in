class CreateCategoriesTempPromotion < ActiveRecord::Migration
  def change
    create_table :categories_temp_promotions do |t|
      t.integer :category_id
      t.integer :temp_promotion_id
    end
  end
end
