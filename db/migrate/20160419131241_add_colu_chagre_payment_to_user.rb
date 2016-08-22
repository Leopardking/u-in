class AddColuChagrePaymentToUser < ActiveRecord::Migration
  def change
    add_column :users, :charge_payment, :boolean, default: false
  end
end
