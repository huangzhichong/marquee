class Admin::ProjectsController < InheritedResources::Base
  layout "admin"
  before_filter :authenticate_user!
  load_and_authorize_resource :only => [:new, :show, :index, :edit, :update]

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
