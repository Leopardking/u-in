class AddCustomerIdToBillingDetails < ActiveRecord::Migration
  def change
    add_column :billing_details, :customer_id, :string
  end
end
