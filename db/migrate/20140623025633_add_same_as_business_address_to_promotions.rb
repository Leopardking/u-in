class AddSameAsBusinessAddressToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :same_as_business_address, :boolean, :default => false
  end
end
