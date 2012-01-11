class Report::VersionTrackingConfig
  include Mongoid::Document

  # split by '#'. E.g., 'Sprint 42 - Team Gold;Sprint 42 - Team Purple'. Must belongs to jira_project
  field :jira_versions_string, type: String 
  field :jira_project, type: String
  field :start_date, type: Date
  field :end_date, type: Date

  has_many :issues, class_name: "Jira::Issue"

  validates_presence_of :jira_project, :jira_versions_string

  def jira_versions
    self.jira_versions_string.split(';')
  end

  def total_bugs_by_priority
    [
      self.issues.all_of(issue_type: 'Bug Sub-Task', priority: 'P0').count + self.issues.all_of(issue_type: 'Bug', priority: 'P0').count,
      self.issues.all_of(issue_type: 'Bug Sub-Task', priority: 'P1').count + self.issues.all_of(issue_type: 'Bug', priority: 'P1').count,
      self.issues.all_of(issue_type: 'Bug Sub-Task', priority: 'P2').count + self.issues.all_of(issue_type: 'Bug', priority: 'P2').count,
      self.issues.all_of(issue_type: 'Bug Sub-Task', priority: 'P3').count + self.issues.all_of(issue_type: 'Bug', priority: 'P3').count,
      self.issues.all_of(issue_type: 'Bug Sub-Task', priority: 'P4').count + self.issues.all_of(issue_type: 'Bug', priority: 'P4').count
    ]
  end

  def total_effort_by_issue_types(issue_types)
    total = 0
    issue_types.each do |issue_type|
      total += self.issues.where(issue_type: issue_type).inject(0){|sum, i| sum += i.time_spent}
    end
    (total / 3600.0).round
  end

  def requirements_done
    self.issues.all_of(issue_type: 'Requirement/ User Story', status: 'Closed').count
  end

  def effort_by_day_and_issue_types(day, issue_types)
    total = 0
    issue_types.each do |issue_type|
      total += self.issues.all_of(issue_type: issue_type).inject(0){|sum, i| sum += i.effort_by_day(day)}
    end
    (total / 3600.0).round
  end
end