class AddAttachmentLogoToMerchantDetails < ActiveRecord::Migration
  def self.up
    change_table :merchant_details do |t|
      t.attachment :logo
    end
  end

  def self.down
    drop_attached_file :merchant_details, :logo
  end
end
