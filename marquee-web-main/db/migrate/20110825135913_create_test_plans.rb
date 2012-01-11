class CreateTestPlans < ActiveRecord::Migration
  def change
    create_table :test_plans do |t|
      t.string :name
      t.string :status
      t.string :version
      t.references :project

      t.timestamps
    end
    add_index :test_plans, :project_id
    add_foreign_key :test_plans, :projects, :dependent => :delete
  end
end
