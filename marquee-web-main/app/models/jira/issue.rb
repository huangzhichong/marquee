class Jira::Issue
  include Mongoid::Document

  field :jira_id, type: Integer # The db id for this stored in Jira DB
  field :summary, type: String # The title on Jira for a ticket
  field :status, type: String
  field :issue_type, type: String # The type of this jira issue. e.g., 'Requirement / User Story', 'Bug Sub-Task'
  field :priority, type: String # String representation of Priority, e.g., 'P0', 'P1', 'P2'
  field :key, type: String # Jira Key, e.g., 'FNDCAMP-8088'
  field :assignee, type: String # Jira Asisgnee
  field :created_at, type: DateTime # Jira issue created at(in Jira Database)
  field :updated_at, type: DateTime # Jira issue updated at(in Jira Database)
  field :time_original_estimate, type: Integer # Original Estimation, in seconds
  field :time_estimate, type: Integer # Estimation left, in seconds
  field :time_spent, type: Integer # Time spent, in seconds

  embeds_many :change_items, class_name: "Jira::ChangeItem"
  embeds_many :work_logs, class_name: "Jira::WorkLog"
  belongs_to :version_tracking_config, class_name: "Report::VersionTrackingConfig"
  has_many :children, class_name: "Jira::Issue", inverse_of: :parent
  belongs_to :parent, class_name: "Jira::Issue", inverse_of: :children

  has_and_belongs_to_many :fix_versions, class_name: "Jira::Version"
  has_and_belongs_to_many :components, class_name: "Jira::Component"

  def total_time_spent
    result = children.inject(0){|sum, child| sum += child.time_spent}
    (result / 3600.0).round
  end

  def time_spent_by_issue_type(issue_type)
    result = children.inject(0) do |sum, child|
      if child.issue_type == issue_type
        sum += child.time_spent
      else
        sum
      end
    end
    (result / 3600.0).round
  end

  def effort_by_day(day)
    self.work_logs.inject(0) do |sum, wl|
      if wl.start_date == day
        sum += wl.time_worked
      end
      sum
    end
  end
end