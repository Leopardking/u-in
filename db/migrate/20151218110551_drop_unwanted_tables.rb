class DropUnwantedTables < ActiveRecord::Migration
  def change
  	drop_table :working_schedules if table_exists?(:working_schedules)
  	drop_table :working_days if table_exists?(:working_days)
  	drop_table :segments if table_exists?(:segments)
  end
end
