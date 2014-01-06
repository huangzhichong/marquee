class AutomationScriptsController < InheritedResources::Base
  respond_to :js
  belongs_to :project

  protected
  def resource
    @project ||= Project.find(params[:project_id])
    @automation_script ||= AutomationScript.find(params[:id])
  end

  def collection
    @project ||= Project.find(params[:project_id])
    @search = @project.automation_scripts.search(params[:search])
    @automation_scripts ||= @search.page(params[:page]).per(15)
  end
end
