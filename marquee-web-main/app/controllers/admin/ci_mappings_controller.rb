class Admin::CiMappingsController < InheritedResources::Base
  belongs_to :project
  layout 'admin'
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
    project = Project.find(params[:project_id])
	ci_mapping_value = params[:ci_mapping][:ci_value].strip
    ci_mappings = project.ci_mappings.where("ci_value = '" + ci_mapping_value + "'")
    if ci_mappings.length > 0 then
      flash[:error] = ci_mapping_value + " already exists"
      render :action => "new"
      return
    end

    params[:ci_mapping][:ci_value] = params[:ci_mapping][:ci_value].strip
    super
  end
end
