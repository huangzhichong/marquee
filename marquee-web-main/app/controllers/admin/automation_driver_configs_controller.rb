class Admin::AutomationDriverConfigsController < InheritedResources::Base

  belongs_to :project
  layout 'admin'
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create

    automation_driver_config = AutomationDriverConfig.new
    automation_driver_config.project_id = params[:project_id]
    automation_driver_config.automation_driver_id = params[:automation_driver_config][:automation_driver_id]
    automation_driver_config.name = params[:automation_driver_config][:name]
    automation_driver_config.source_control = params[:automation_driver_config][:source_control]
    automation_driver_config.source_paths = params[:source_path] ? JSON.generate(params[:source_path].values) : nil
    automation_driver_config.script_main_path = params[:automation_driver_config][:script_main_path]
    automation_driver_config.sc_username = params[:automation_driver_config][:sc_username]
    automation_driver_config.sc_password = params[:automation_driver_config][:sc_password]
    automation_driver_config.save

    if automation_driver_config.errors.any?
      @automation_driver_config = automation_driver_config
      render :new and return
    else
      redirect_to admin_project_automation_driver_configs_url
    end
      
  end

  def update

    params["automation_driver_config"]["source_paths"] = params["source_path"] ? JSON.generate(params["source_path"].values) : nil

    update!{admin_project_automation_driver_configs_url(@project)}
  end

  def destroy

    AutomationScript.find_all_by_automation_driver_config_id(params[:id]).each do |as|
      as.automation_driver_config = nil
      as.save
    end

    destroy!{admin_project_automation_driver_configs_url}
  end

end
