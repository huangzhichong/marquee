class CreateOracleProjectPermissions < ActiveRecord::Migration
  def change
    create_table :oracle_project_permissions do |t|
      t.references :user
      t.references :oracle_project

      t.timestamps
    end
    add_index :oracle_project_permissions, :user_id
    add_index :oracle_project_permissions, :oracle_project_id
  end
end
