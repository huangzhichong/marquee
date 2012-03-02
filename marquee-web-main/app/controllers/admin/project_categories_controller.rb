class Admin::ProjectCategoriesController < InheritedResources::Base
  layout 'admin'
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
    project_category_name = params[:project_category][:name].strip
    project_categories = ProjectCategory.find_all_by_name(project_category_name)
    if project_categories.length > 0 then
      flash[:error] = project_category_name + " already exists"
      render :action => "new" and return
    end

    params[:project_category][:name] = params[:project_category][:name].strip
    super
  end
end
