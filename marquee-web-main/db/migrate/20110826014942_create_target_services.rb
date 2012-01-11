class CreateTargetServices < ActiveRecord::Migration
  def change
    create_table :target_services do |t|
      t.string :name
      t.string :version
      t.references :automation_script_result

      t.timestamps
    end
    add_index :target_services, :automation_script_result_id
    add_foreign_key :target_services, :automation_script_results, :dependent => :delete
  end
end
