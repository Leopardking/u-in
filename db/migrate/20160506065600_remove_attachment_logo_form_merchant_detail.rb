class RemoveAttachmentLogoFormMerchantDetail < ActiveRecord::Migration
  def self.up
    drop_attached_file :merchant_details, :logo
  end

  def self.down
    change_table :merchant_details do |t|
      t.attachment :logo
    end
  end
end
