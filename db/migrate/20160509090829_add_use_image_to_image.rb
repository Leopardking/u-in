class AddUseImageToImage < ActiveRecord::Migration
  def change
    add_column :images, :using_image, :string
  end
end
