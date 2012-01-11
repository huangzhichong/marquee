class CreateTestRounds < ActiveRecord::Migration
  def change
    create_table :test_rounds do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :state
      t.string :result
      t.string :test_object
      t.integer :pass
      t.integer :warning
      t.integer :failed
      t.integer :not_run
      t.float :pass_rate
      t.integer :duration
      t.string :triage_result
      t.references :test_environment
      t.references :project
      t.integer :creator_id
      t.references :test_suite

      t.timestamps
    end
    add_index :test_rounds, :test_environment_id
    add_index :test_rounds, :project_id
    add_index :test_rounds, :test_suite_id
    add_index :test_rounds, :creator_id

    add_foreign_key :test_rounds, :test_environments, :dependent => :delete
    add_foreign_key :test_rounds, :projects, :dependent => :delete
    add_foreign_key :test_rounds, :test_suites, :dependent => :delete
  end
end
