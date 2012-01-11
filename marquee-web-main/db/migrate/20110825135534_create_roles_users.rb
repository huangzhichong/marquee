class CreateRolesUsers < ActiveRecord::Migration
  def change
    create_table :roles_users, :id => false do |t|
      t.references :role
      t.references :user
    end

    add_index :roles_users, :role_id
    add_index :roles_users, :user_id

    add_foreign_key :roles_users, :users, :dependent => :delete
    add_foreign_key :roles_users, :roles, :dependent => :delete
  end
end
