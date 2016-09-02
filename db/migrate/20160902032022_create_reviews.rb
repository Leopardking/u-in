class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
    	t.references :user, index: true
    	t.references :promotion, index: true
    	t.text :content
    	t.float :rating
      t.timestamps
    end
  end
end
