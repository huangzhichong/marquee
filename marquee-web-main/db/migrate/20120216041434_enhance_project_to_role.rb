class EnhanceProjectToRole < ActiveRecord::Migration

  def up

    begin
      if !table_exists?(:projects_roles)
        create_table :projects_roles do |t|
          t.references :project
          t.references :role
        end

        add_index :projects_roles, :project_id, :name => "idx_pr_p"
        add_index :projects_roles, :role_id, :name => "idx_pr_r"

        add_foreign_key :projects_roles, :projects, :name => "fk_pr_p"
        add_foreign_key :projects_roles, :roles, :name => "fk_pr_r"
      else
        say "Table :projects_roles already exists."
      end

      if !table_exists?(:projects_roles_users)
        create_table :projects_roles_users, :id => false do |t|
          t.references :user
          t.integer :projects_roles_id
        end

        add_index :projects_roles_users, :user_id, :name => "idx_pru_u"
        add_index :projects_roles_users, :projects_roles_id, :name => "idx_pru_pr"

        add_foreign_key :projects_roles_users, :users, :name => "fk_pru_p"
        add_foreign_key :projects_roles_users, :projects_roles, :column => "projects_roles_id", :name => "fk_pru_pr"
      else
        say "Table :projects_roles_users already exists."
      end
    rescue
      say "Error occurs. Deleting table :projects_roles_users and :projects_roles."
      down
      raise
    end

  end

  def down

    drop_table :projects_roles_users if table_exists?(:projects_roles_users)
    drop_table :projects_roles if table_exists?(:projects_roles)

  end 

end
