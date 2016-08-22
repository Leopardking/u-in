class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.attachment :image
      t.references :promotion, index: true

      t.timestamps
    end
  end
end
