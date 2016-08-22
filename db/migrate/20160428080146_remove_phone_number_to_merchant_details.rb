class RemovePhoneNumberToMerchantDetails < ActiveRecord::Migration
  def change
  	remove_column :merchant_details, :phone_number, :string
  end
end
