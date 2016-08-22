class ChangeTypeSavePriceToPromotion < ActiveRecord::Migration
  def up
    change_column :promotions, :saving_price, :decimal
  end
  def down
    change_column :promotions, :saving_price, :float
  end
end
