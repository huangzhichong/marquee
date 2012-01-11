class CreateMailNotifyGroupsMailNotifySettings < ActiveRecord::Migration
  def change
    create_table :mail_notify_groups_mail_notify_settings, :id => false do |t|
      t.belongs_to :mail_notify_setting
      t.belongs_to :mail_notify_group

      t.timestamps
    end
    add_index :mail_notify_groups_mail_notify_settings, :mail_notify_setting_id, :name => "index_mns_on_mng"
    add_index :mail_notify_groups_mail_notify_settings, :mail_notify_group_id, :name => "index_mng_on_mns"

    add_foreign_key :mail_notify_groups_mail_notify_settings, :mail_notify_settings, :name => "fk_mngmns_on_mns", :dependent => :delete
    add_foreign_key :mail_notify_groups_mail_notify_settings, :mail_notify_groups, :name => "fk_mngms_on_mng", :dependent => :delete
  end
end
