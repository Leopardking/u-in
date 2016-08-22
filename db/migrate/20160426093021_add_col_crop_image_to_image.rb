class AddColCropImageToImage < ActiveRecord::Migration
  def change
    add_column :images, :crop_x, :decimal
    add_column :images, :crop_y, :decimal
    add_column :images, :crop_w, :decimal
    add_column :images, :crop_h, :decimal
  end
end
