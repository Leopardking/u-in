class AddInfoColumToBillingDetail < ActiveRecord::Migration
  def change
    add_column :billing_details, :same_as_company_address, :boolean, default: false
    add_column :billing_details, :street_address_2, :string
    add_column :billing_details, :email, :string
    add_column :billing_details, :phone, :integer
    add_column :billing_details, :name_card, :string
    add_column :billing_details, :exp_month, :integer
    add_column :billing_details, :exp_year, :integer
    add_column :billing_details, :security_code, :string
  end
end
