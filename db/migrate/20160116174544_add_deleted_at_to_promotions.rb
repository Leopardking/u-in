class AddDeletedAtToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :deleted_at, :datetime
    add_index :promotions, :deleted_at
  end
end
