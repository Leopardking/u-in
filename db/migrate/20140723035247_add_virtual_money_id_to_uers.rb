class AddVirtualMoneyIdToUers < ActiveRecord::Migration
  def change
    add_column :users, :virtual_money, :float, :default => 0.00
  end
end
