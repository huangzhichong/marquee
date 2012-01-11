class CreateAutomationScripts < ActiveRecord::Migration
  def change
    create_table :automation_scripts do |t|
      t.string :name
      t.string :status
      t.string :version
      t.references :test_plan
      t.integer :owner_id
      t.references :project

      t.timestamps
    end
    add_index :automation_scripts, :test_plan_id
    add_index :automation_scripts, :project_id

    add_foreign_key :automation_scripts, :test_plans, :dependent => :delete
    add_foreign_key :automation_scripts, :projects, :dependent => :delete
  end
end
