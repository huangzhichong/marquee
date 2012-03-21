class Admin::TestSuitesController < InheritedResources::Base
  belongs_to :project
  respond_to :js
  layout "admin"
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
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
    @search = @project.test_suites.search(params[:search])
    @admin_test_suites ||= @search.order('id desc').page(params[:page]).per(15)
  end
end
