class ChangeTypeColumnSavingPriceToPromotion < ActiveRecord::Migration
  def up
    change_column :promotions, :saving_price, :float
  end
  def down
    change_column :promotions, :saving_price, :decimal
  end
end
