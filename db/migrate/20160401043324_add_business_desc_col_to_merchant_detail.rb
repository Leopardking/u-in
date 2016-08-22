class AddBusinessDescColToMerchantDetail < ActiveRecord::Migration
  def change
    add_column :merchant_details, :business_desc, :text
  end
end
