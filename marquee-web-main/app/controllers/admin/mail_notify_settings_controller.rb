class Admin::MailNotifySettingsController < InheritedResources::Base
  belongs_to :project
  layout "admin"
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
    create!{admin_project_mail_notify_settings_url(@project)}
  end

  def update
    update!{admin_project_mail_notify_settings_url(@project)}
  end
end
