class CreateSlaveAssignments < ActiveRecord::Migration
  def change
    create_table :slave_assignments do |t|
      t.references :automation_script_result
      t.references :slave
      t.string :status

      t.timestamps
    end
    add_index :slave_assignments, :automation_script_result_id
    add_index :slave_assignments, :slave_id
    add_foreign_key :slave_assignments, :automation_script_results, :dependent => :delete
    add_foreign_key :slave_assignments, :slaves, :column => 'slave_id', :dependent => :delete
  end
end
