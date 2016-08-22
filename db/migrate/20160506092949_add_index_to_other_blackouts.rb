class AddIndexToOtherBlackouts < ActiveRecord::Migration
  def change
    add_index :other_blackouts, :promotion_id
  end
end
