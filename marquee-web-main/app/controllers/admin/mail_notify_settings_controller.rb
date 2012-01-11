class Admin::MailNotifySettingsController < InheritedResources::Base
  belongs_to :project
  layout "admin"
  before_filter :authenticate_user!
  load_and_authorize_resource
end
