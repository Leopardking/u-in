class AddDescriptionImageToImage < ActiveRecord::Migration
  def change
    add_column :images, :description_image, :text
  end
end
