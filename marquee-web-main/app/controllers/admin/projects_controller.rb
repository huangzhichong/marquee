class Admin::ProjectsController < InheritedResources::Base
  layout "admin"
  before_filter :authenticate_user!
  load_and_authorize_resource :only => [:new, :show, :index, :edit, :update]

  def create
    project_name = params[:project][:name].strip
    projects = Project.find_all_by_name(project_name)

    if projects.length > 0 then
      flash[:error] = project_name + " already exists"
      @project = project = Project.new(:name => project_name, :leader_id => params[:project][:leader_id],
        :test_link_plan => params[:project][:test_link_plan],
        :source_control_path => params[:project][:source_control_path])
      render :action => "new" and return
    end

    params[:project][:name] = params[:project][:name].strip
    super
  end

  def display_order

  end

  def display_order_update
    display_order = 0
    params[:slides].each do |project_name|
      unless project_name.blank?
        project = Project.find_by_name(project_name)
        project.display_order = display_order
        display_order += 1
        project.save
      end
    end

    redirect_to admin_projects_display_order_path
  end
end
