class AddImageNoToImages < ActiveRecord::Migration
  def change
    add_column :images, :image_no, :integer
  end
end
