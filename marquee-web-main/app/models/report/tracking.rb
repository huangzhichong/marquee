class Report::Tracking
  include Mongoid::Document
  field :pulled_at, type: Date
  field :total_time_worked, type: Integer
  field :in_release_time_worked, type: Integer
  field :out_of_release_time_worked, type: Integer
  field :out_of_project_time_worked, type: Integer
  field :total_open_bugs_count, type: Integer
  field :p0_open_bugs_count, type: Integer
  field :p1_open_bugs_count, type: Integer
  field :p2_open_bugs_count, type: Integer
  field :p3_open_bugs_count, type: Integer
  field :p4_open_bugs_count, type: Integer
  field :daily_open_bugs_count_string, type: String  

  embeds_many :work_logs, class_name: "Report::WorkLog"
  embedded_in :config, class_name: "Report::InDevelopmentTrackingConfig"

  def time_spent_on_new_features
    results = self.work_logs.find_all do |work_log|
      work_log.in_release and ['Dev Sub-Task', 'Dev Task', 'Research Sub-Task', 'Requirement/ User Story', 'Roadmap Feature'].include? work_log.category
    end
    results.inject(0){|sum, wl| sum += wl.time_worked}
  end

  def time_spent_on_bug_sub_tasks
    results = self.work_logs.find_all do |work_log|
      work_log.in_release and 'Bug Sub-Task' == work_log.category
    end
    results.inject(0){|sum, wl| sum += wl.time_worked}
  end

  def time_spent_on_bugs
    results = self.work_logs.find_all do |work_log|
      work_log.in_release and 'Bug' == work_log.category and work_log.environment != 'Production'
    end
    results.inject(0){|sum, wl| sum += wl.time_worked}
  end

  def time_spent_on_production_support
    results = self.work_logs.find_all do |work_log|
      work_log.environment == 'Production'
    end
    results.inject(0){|sum, wl| sum += wl.time_worked}
  end

  def time_spent_on_extra_category(category)
    results = self.work_logs.find_all do |work_log|
      work_log.sub_task_key == category.jira_key
    end
    results.inject(0){|sum, wl| sum += wl.time_worked}
  end

  # def time_spent_on_environment_issues
  #   results = self.work_logs.find_all do |work_log|
  #     work_log.sub_task_key == 'FNDENDR-15155'
  #   end
  #   results.inject(0){|sum, wl| sum += wl.time_worked}
  # end

  # def time_spent_on_pto
  #   results = self.work_logs.find_all do |work_log|
  #     work_log.sub_task_key == 'FNDENDR-15106'
  #   end
  #   results.inject(0){|sum, wl| sum += wl.time_worked}
  # end

  # def time_spent_on_general_support
  #   results = self.work_logs.find_all do |work_log|
  #     work_log.sub_task_key == 'FNDENDR-15108'
  #   end
  #   results.inject(0){|sum, wl| sum += wl.time_worked}
  # end

  # def time_spent_on_anlysis_and_design
  #   results = self.work_logs.find_all do |work_log|
  #     work_log.sub_task_key == 'FNDENDR-15107'
  #   end
  #   results.inject(0){|sum, wl| sum += wl.time_worked}
  # end
end