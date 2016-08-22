class AddColFreeBookingToMerchantDetail < ActiveRecord::Migration
  def change
    add_column :merchant_details, :booking_free, :string, default: 20
  end
end
