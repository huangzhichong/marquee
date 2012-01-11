class ProjectsController < InheritedResources::Base
  def index
    if params[:search]
      @project = Project.find_by_name(params[:search])
      redirect_to project_path(@project) if @project
    end
    @projects = Project.scoped
  end

  def coverage
    @project = Project.find(params[:id])
    project_name = @project.name
    # @p1_covergae = Rails.cache.fetch("#{project_name}_p1_covergae"){ Project.caculate_coverage_by_project_and_priority(project_name, "P1") }
    # @p2_covergae = Rails.cache.fetch("#{project_name}_p2_covergae"){ Project.caculate_coverage_by_project_and_priority(project_name, "P2") }
    # @p3_covergae = Rails.cache.fetch("#{project_name}_p3_covergae"){ Project.caculate_coverage_by_project_and_priority(project_name, "P3") }
    # @overall_coverage = Rails.cache.fetch("#{project_name}_overall_coverage"){ Project.caculate_overall_coverage_by_project(project_name) }
    
    @cui_coverage = []
    @aui_coverage = []
    @coverage = []
    %w(Overall P1 P2 P3).each do |priority|
      @cui_coverage << Project.caculate_coverage_by_project_and_priority_and_type(project_name, priority,"CUI")
      @aui_coverage << Project.caculate_coverage_by_project_and_priority_and_type(project_name, priority,"AUI")
      @coverage << Project.caculate_coverage_by_project_and_priority(project_name,priority)
    end
    
    # @aui_overall_goal = 95.0
    # @aui_p1_goal = 95.0
    # @aui_p2_goal = 95.0
    # @aui_p3_goal = 95.0
    
    # @cui_overall_goal = 90.0
    # @cui_p1_goal = 90.0
    # @cui_p2_goal = 90.0
    # @cui_p3_goal = 90.0
    
    # p1_goal = (project_name == "Camps") ? 95 : 90
    # p2_goal = (project_name == "Camps") ? 95 : 90
    # p3_goal = (project_name == "Camps") ? 95 : 90
    # overall_goal = (project_name == "Camps") ? 95 : 90
    
    # @p1_goal = Rails.cache.fetch("#{project_name}_p1_goal"){ p1_goal }
    # @p2_goal = Rails.cache.fetch("#{project_name}_p2_goal"){ p2_goal }
    # @p3_goal = Rails.cache.fetch("#{project_name}_p3_goal"){ p3_goal }
    # @overall_goal = Rails.cache.fetch("#{project_name}_overall_goal"){ overall_goal }
  end

end
