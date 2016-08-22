class CreateMerchantDetails < ActiveRecord::Migration
  def change
    create_table :merchant_details do |t|
      t.string :business_name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :phone_number
      t.float :lat
      t.float :lng
      t.references :user, index: true

      t.timestamps
    end
  end
end
