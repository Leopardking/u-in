class CreateHistoryVMoneys < ActiveRecord::Migration
  def change
    create_table :history_v_moneys do |t|
      t.references :user, index: true
      t.integer :action
      t.references :promotion, index: true
      t.float :amount
      t.timestamps
    end
  end
end
