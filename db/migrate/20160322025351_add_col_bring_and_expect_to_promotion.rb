class AddColBringAndExpectToPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :bring_item, :string
    add_column :promotions, :expect, :string
  end
end
