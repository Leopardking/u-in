class AddCancelStatusToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :cancel_status, :boolean, :default => false
  end
end
