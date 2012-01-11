class RemoveTestTypeFromMailNotifySettings < ActiveRecord::Migration
  def up
    remove_foreign_key :mail_notify_settings, :test_types
    remove_index :mail_notify_settings, :test_type_id
    remove_column :mail_notify_settings, :test_type_id
  end

  def down
    add_column :mail_notify_settings, :test_type_id, :integer
    add_index :automation_case_results, :automation_script_result_id
    add_foreign_key :mail_notify_settings, :test_types, :dependent => :delete
  end
end
