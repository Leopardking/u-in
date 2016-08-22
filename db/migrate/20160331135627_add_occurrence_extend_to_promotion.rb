class AddOccurrenceExtendToPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :occurrence_extend, :string
  end
end
