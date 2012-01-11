class TestRoundsController < InheritedResources::Base
  respond_to :js
  belongs_to :project
  before_filter :authenticate_user!, :only => [:new, :crete]

  def create
    create! do
      @test_round.set_default_value
      @test_round.save
      @test_round.init_automation_script_result
      LongTasks.new.delay.distribute_test_round_task(@test_round)
      project_test_rounds_path(@project)
    end
  end

  protected
  def resource
    @project ||= Project.find(params[:project_id])
    @test_round ||= TestRound.find(params[:id])
    @search = @test_round.automation_script_results.order('id desc').search(params[:search])
    @automation_script_results = @search.page(params[:page]).per(15)
  end

  def collection
    @project ||= Project.find(params[:project_id])
    @search = @project.test_rounds.order('id desc').search(params[:search])
    @test_rounds ||= @search.page(params[:page]).per(15)
  end
  
end
