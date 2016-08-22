class AddUserTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_type, :string
    add_column :users, :admin, :boolean, default: true
  end
end
