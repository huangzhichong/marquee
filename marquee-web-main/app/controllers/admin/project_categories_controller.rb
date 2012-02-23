class Admin::ProjectCategoriesController < InheritedResources::Base
  layout 'admin'
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
    project_category_name = params[:project_category][:name].strip
    project_categorys = ProjectCategory.where("name = '" + project_category_name + "'")
    if project_categorys.length > 0 then
      flash[:error] = project_category_name + " already exists"
      render :action => "new"
      return
    end

    super
  end
end
