class AddColunmTimeBeginChargeToUser < ActiveRecord::Migration
  def change
    add_column :users, :time_charge, :datetime
  end
end
