class Admin::MailNotifySettingsController < InheritedResources::Base
  belongs_to :project
  layout "admin"
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
    project = Project.find(params[:project_id])
    mail = params[:mail_notify_setting][:mail].strip
    mails = project.mail_notify_settings.find_all_by_mail(mail)
    if mails.length > 0 then
      flash[:error] = mail + " already exists"
      render :action => "new" and return
    end

    super
  end
end
