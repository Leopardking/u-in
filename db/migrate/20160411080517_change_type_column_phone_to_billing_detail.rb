class ChangeTypeColumnPhoneToBillingDetail < ActiveRecord::Migration
  def up
    change_column :billing_details, :phone, :string
  end
  def down
    change_column :billing_details, :phone, :integer
  end
end
