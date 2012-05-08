class Admin::MailNotifySettingsController < InheritedResources::Base
  # respond_to :js
  belongs_to :project
  layout "admin"
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
    project_id = params[:project_id]
    mail = params[:mail_notify_setting][:mail]
    mail_notify_group_ids = params[:mail_notify_setting][:mail_notify_group_ids]
    test_type_ids = params[:mail_notify_setting][:test_type_ids]

    existing_mail_notify_settings_list = MailNotifySetting.joins(:mail_notify_groups, :test_types).where(:project_id => project_id, :mail => mail, "mail_notify_groups.id" => mail_notify_group_ids, "test_types.id" => test_type_ids)

    respond_to do |format|
      if existing_mail_notify_settings_list && existing_mail_notify_settings_list.empty?
        project = Project.find(project_id)
        mns = MailNotifySetting.new(:mail => mail)
        mns.project = project

        mail_notify_group_ids.each do |mng_id|
          mng = nil
          mng = MailNotifyGroup.find(mng_id) unless mng_id == ""
          mns.mail_notify_groups << mng if mng
        end

        test_type_ids.each do |type_id|
          test_type = nil
          test_type = TestType.find(type_id) unless type_id == ""
          mns.test_types << test_type if test_type
        end
        mns.save
        
        format.js { render :json => {:result => "success"}}
      else
        format.js { render :json => {:result => "failed"}}
      end
    end
  end

  def update
    # update!{admin_project_mail_notify_settings_url(@project)}
    id = params[:id]
    project_id = params[:project_id]
    mail = params[:mail_notify_setting][:mail]
    mail_notify_group_ids = params[:mail_notify_setting][:mail_notify_group_ids]
    test_type_ids = params[:mail_notify_setting][:test_type_ids]

    existing_mail_notify_settings_list = MailNotifySetting.joins(:mail_notify_groups, :test_types).where(:project_id => project_id, :mail => mail, "mail_notify_groups.id" => mail_notify_group_ids, "test_types.id" => test_type_ids)

    mns = MailNotifySetting.find(id)
    respond_to do |format|
      if mns
        if existing_mail_notify_settings_list && existing_mail_notify_settings_list.empty?
          mns.mail = mail
          mns.mail_notify_groups.delete_all
          mns.test_types.delete_all

          mail_notify_group_ids.each do |mng_id|
            m = nil
            m = MailNotifyGroup.find(mng_id) unless mng_id == ""
            mns.mail_notify_groups << m if m
          end

          test_type_ids.each do |type_id|
            test_type = nil
            test_type = TestType.find(type_id) unless type_id == ""
            mns.test_types << test_type if test_type
          end
          mns.save
          format.js { render :json => {:result => "success"}}
        else
          format.js { render :json => {:result => "failed"}}
        end
      else
        format.js { render :json => {:result => "Can not find this mail_notify_setting!"}}
      end
    end
  end
end
