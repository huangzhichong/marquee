class CreateMailNotifySettings < ActiveRecord::Migration
  def change
    create_table :mail_notify_settings do |t|
      t.string :mail
      t.references :project
      t.references :test_type

      t.timestamps
    end
    add_index :mail_notify_settings, :project_id
    add_index :mail_notify_settings, :test_type_id
    add_foreign_key :mail_notify_settings, :projects, :dependent => :delete
    add_foreign_key :mail_notify_settings, :test_types, :dependent => :delete

  end
end
