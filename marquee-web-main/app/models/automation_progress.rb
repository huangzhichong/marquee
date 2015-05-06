class AutomationProgress < ActiveRecord::Base
  belongs_to :project
  def save_regression_coverage
    @project = self.project    
    self.total_case = @project.count_test_case_by_plan_type_and_options('regression',{})
    self.total_automated = @project.count_test_case_by_plan_type_and_options('regression',:automated_status => "Automated")
    self.not_candidate = @project.count_test_case_by_plan_type_and_options('regression',:automated_status => "Not a Candidate")
    self.save
  end
end
