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
    @regression_coverage = []
    %w(Overall P1 P2 P3).each do |priority|
      @cui_coverage << Project.caculate_coverage_by_project_and_priority_and_type(project_name, priority,"CUI")
      @aui_coverage << Project.caculate_coverage_by_project_and_priority_and_type(project_name, priority,"AUI")
      @regression_coverage << Project.caculate_coverage_by_project_and_priority_and_type(project_name, priority,"regression")
      @coverage << Project.caculate_coverage_by_project_and_priority(project_name,priority)
    end
    %W(P1 P2 P3).each do |priority|
      eval "@#{priority}_automated = @project.count_test_case_by_options({:automated_status => 'Automated',:priority => '#{priority}'})"
      eval "@#{priority}_update_needed = @project.count_test_case_by_options({:automated_status => 'Update Needed',:priority => '#{priority}'})"
      eval "@#{priority}_not_candidate = @project.count_test_case_by_options({:automated_status => 'Not a Candidate',:priority => '#{priority}'})"
      eval "@#{priority}_total = @project.count_test_case_by_options({:priority => '#{priority}'})"
    end
    @total_automated =  @project.count_test_case_by_options(:automated_status => "Automated")
    @total_update_needed = @project.count_test_case_by_options(:automated_status => "Update Needed")
    @total_not_candidate = @project.count_test_case_by_options(:automated_status => "Not a Candidate")
    @total = @project.count_test_case_by_options
  end

end
