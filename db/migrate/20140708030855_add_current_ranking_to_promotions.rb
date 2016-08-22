class AddCurrentRankingToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :current_rank, :integer
  end
end
