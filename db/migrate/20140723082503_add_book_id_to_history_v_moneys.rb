class AddBookIdToHistoryVMoneys < ActiveRecord::Migration
  def change
    add_reference :history_v_moneys, :booking, index: true
  end
end
