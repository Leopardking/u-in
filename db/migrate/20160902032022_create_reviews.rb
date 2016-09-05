class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
    	t.references :user, index: true
    	t.references :promotion, index: true
    	t.text :content
    	t.float :rating, default: 2.5
      t.timestamps
    end
  end
end
