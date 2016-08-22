class ChangeDataTypeForStartDate < ActiveRecord::Migration
  def up
    change_table :promotions do |t|
      t.change :start_date, :date
    end
  end

  def down
    change_table :promotions do |t|
      t.change :start_date, :string
    end
  end
end
