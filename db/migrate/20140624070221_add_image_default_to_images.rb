class AddImageDefaultToImages < ActiveRecord::Migration
  def change
    add_column :images, :image_default, :boolean, :default => false
  end
end
