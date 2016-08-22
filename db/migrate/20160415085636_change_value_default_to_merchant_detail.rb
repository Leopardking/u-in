class ChangeValueDefaultToMerchantDetail < ActiveRecord::Migration
  def change
    change_column :merchant_details, :booking_free, :integer, default: 0
  end
end
