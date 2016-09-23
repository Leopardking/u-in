class AddColumnHideOnReview < ActiveRecord::Migration
  def change
  	add_column :reviews, :listing_show, :boolean, default: true
  end
end
