class CreateBillingDetails < ActiveRecord::Migration
  def change
    create_table :billing_details do |t|
      t.string :card_type
      t.string :ccard_last4
      t.string :stripe_profile_token
      t.string :first_name
      t.string :last_name
      t.string :street_address
      t.string :city
      t.string :zipcode
      t.string :state
      t.boolean :always_use
      t.references :user, index: true

      t.timestamps
    end
  end
end
