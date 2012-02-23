class Admin::MailNotifySettingsController < InheritedResources::Base
  belongs_to :project
  layout "admin"
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
    project = Project.find(params[:project_id])
	mail = params[:mail_notify_setting][:mail].strip
    mails = project.mail_notify_settings.where("mail = '" + mail + "'")
    if mails.length > 0 then
      flash[:error] = mail + " already exists"
      render :action => "new"
      return
    end

    super
  end
end
