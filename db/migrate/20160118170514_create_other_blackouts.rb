class CreateOtherBlackouts < ActiveRecord::Migration
  def change
    create_table :other_blackouts do |t|
      t.datetime :blackout_from
      t.datetime :blackout_to
      t.belongs_to :promotion
      t.timestamps
    end
  end
end
