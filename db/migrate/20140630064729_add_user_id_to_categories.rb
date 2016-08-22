class AddUserIdToCategories < ActiveRecord::Migration
  def change
    change_table :categories do |t|
      t.belongs_to :user
    end
  end
end
