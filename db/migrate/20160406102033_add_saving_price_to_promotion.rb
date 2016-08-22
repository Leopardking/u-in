class AddSavingPriceToPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :saving_price, :float
  end
end
