class ChangeTypeColumnBookFreeToMerchantDetail < ActiveRecord::Migration
  def change
    change_column :merchant_details, :booking_free, :integer
  end
end
