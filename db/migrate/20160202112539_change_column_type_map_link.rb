class ChangeColumnTypeMapLink < ActiveRecord::Migration
  def change
  	change_column :promotions, :google_map_link, :text
  end
end
