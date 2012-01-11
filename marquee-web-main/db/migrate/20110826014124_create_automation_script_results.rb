class CreateAutomationScriptResults < ActiveRecord::Migration
  def change
    create_table :automation_script_results do |t|
      t.string :state
      t.integer :pass
      t.integer :failed
      t.integer :warning
      t.integer :not_run
      t.string :result
      t.datetime :start_time
      t.datetime :end_time
      t.references :test_round
      t.references :automation_script

      t.timestamps
    end
    add_index :automation_script_results, :test_round_id
    add_index :automation_script_results, :automation_script_id

    add_foreign_key :automation_script_results, :test_rounds, :dependent => :delete
    add_foreign_key :automation_script_results, :automation_scripts, :dependent => :delete
  end
end
