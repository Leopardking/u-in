class AddColBookFreeToUser < ActiveRecord::Migration
  def change
    add_column :users, :booking_free, :integer, default: 0
  end
end
