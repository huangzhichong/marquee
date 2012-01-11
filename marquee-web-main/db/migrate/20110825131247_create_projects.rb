class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :leader_id
      t.references :project_category
      t.string :source_control_path
      t.string :icon_image_file_name
      t.string :icon_image_content_type
      t.integer :icon_image_file_size
      t.string :state

      t.timestamps
    end
    add_index :projects, :project_category_id
    add_index :projects, :leader_id

    add_foreign_key :projects, :users, :column => 'leader_id'
    add_foreign_key :projects, :project_categories, :dependent => :delete
  end
end
