class RemoveBookFreeFromMerchantDetail < ActiveRecord::Migration
  def change
    remove_column :merchant_details, :booking_free, :integer
  end
end
