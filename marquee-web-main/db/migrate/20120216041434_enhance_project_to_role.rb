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

      # create project_role for role and using nil as project 
      role_cache = Hash.new
      ProjectsRolesUsers.delete_all
      RolesUsers.all.each do |ru|
        project_role_id = nil
        user_id = ru.user_id
        if role_cache.has_key?(ru.role_id)
          project_role_id = role_cache.fetch(ru.role_id)
        else
          project_role = ProjectsRoles.find_by_role_id_and_project_id(ru.role_id)
          project_role = ProjectsRoles.new(:role_id => ru.role_id, :project_id => nil) if project_role.nil?
          project_role.save
          project_role_id = project_role.id
          role_cache[ru.role_id] = project_role_id
        end
        project_role_user = ProjectsRolesUsers.new(:projects_roles_id => project_role_id, :user_id => ru.user_id)
        project_role_user.save!
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
