class TestSuitesController < InheritedResources::Base
  respond_to :js
  belongs_to :project
  load_and_authorize_resource

  def show
    @search = @test_suite.automation_scripts.search(params[:search])
    @automation_scripts = @search.page(params[:page]).per(15)
    show!{resource_url}
  end

  def create
    create!{collection_url}
  end

  def update
    update!{collection_url}
  end

  def destroy
    destroy!{collection_url}
  end

  protected

  def resource
    @project = Project.find(params[:project_id])
    @test_suite = TestSuite.find(params[:id])
  end

  def collection
    @project ||= Project.find(params[:project_id])
    @search = @project.test_suites.search(params[:search])
    @test_suites = @search.page(params[:page]).per(15)
  end
end
