class CreateSuiteSelections < ActiveRecord::Migration
  def change
    create_table :suite_selections, :id => false do |t|
      t.references :test_suite
      t.references :automation_script

      t.timestamps
    end
    add_index :suite_selections, :test_suite_id
    add_index :suite_selections, :automation_script_id

    add_foreign_key :suite_selections, :test_suites, :dependent => :delete
    add_foreign_key :suite_selections, :automation_scripts, :dependent => :delete
  end
end
