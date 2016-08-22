class AddColumnsToImage < ActiveRecord::Migration

  def up
    add_column :images, :imageable_id, :integer
    add_column :images, :imageable_type, :string
    Image.transaction do
      Image.find_each do |pt|
        pt.update_attributes(imageable_id: pt.promotion_id, imageable_type: "Promotion")
      end
    end

    remove_column :images, :promotion_id
  end

  def down
    add_column :images, :promotion_id, :integer
    Image.transaction do
      Image.find_each do |pt|
        pt.update_attributes(promotion_id: pt.imageable_id)
      end
    end
    remove_column :images, :imageable_id, :integer
    remove_column :images, :imageable_type, :string
  end
end
