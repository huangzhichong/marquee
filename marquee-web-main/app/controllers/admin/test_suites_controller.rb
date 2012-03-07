class Admin::TestSuitesController < InheritedResources::Base
  belongs_to :project
  respond_to :js
  layout "admin"
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
    project = Project.find(params[:project_id])
    test_suite_name = params[:test_suite][:name].strip
    test_suites = project.test_suites.find_all_by_name(test_suite_name)
    if test_suites.length > 0 then
      flash[:error] = test_suite_name + " already exists"
      render :action => "new" and return
    end

    params[:test_suite][:name] = params[:test_suite][:name].strip
    create!{admin_project_test_suites_url(@project)}
  end

  def update
    update!{admin_project_test_suites_url(@project)}
  end

  def search_automation_script
    project = Project.find(params[:project_id])
    automation_scripts = project.automation_scripts.where("name LIKE '%#{params[:as_name]}%'")
    respond_to do |format|
      format.js { render :json => {:automation_scripts => automation_scripts} }
    end
  end

  protected
  def resource
    @project ||= Project.find(params[:project_id])
    @test_suite ||= TestSuite.find(params[:id])
  end

  def collection
    @project ||= Project.find(params[:project_id])
    @search = @project.test_suites.order('id desc').search(params[:search])
    @admin_test_suites ||= @search.page(params[:page]).per(15)
  end
end
