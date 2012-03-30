class Admin::SlavesController < InheritedResources::Base

  layout 'admin'
  respond_to :js

  before_filter :authenticate_user!
  load_and_authorize_resource

  def collection
    @search = Slave.scoped.search(params[:search])
    @slaves = @search.page(params[:page]).order('name').per(15)
  end

  def create

    set_project_name(params)
    set_test_type(params)

    create!{admin_slaves_url}
  end

  def update

    set_project_name(params)
    set_test_type(params)

    update!{admin_slaves_url}
  end

  private

  def set_project_name(params)
    if params[:slave_projects] and !params[:slave_projects].empty?
      params[:slave][:project_name] = params[:slave_projects].join(",")
    else
      params[:slave][:project_name] = ""
    end
  end

  def set_test_type(params)
    if params[:slave_test_types] and !params[:slave_test_types].empty?
      params[:slave][:test_type] = params[:slave_test_types].join(",")
    else
      params[:slave][:test_type] = ""
    end    
  end

end
