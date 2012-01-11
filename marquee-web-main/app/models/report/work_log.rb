class Report::WorkLog
  include Mongoid::Document
  field :jira_id, type: String
  field :category, type: String
  field :sub_task_key, type: String
  field :start_date, type: Date
  field :enter_date, type: Date
  field :worker, type: String
  field :time_worked, type: Integer

  # merely for in development effort tracking purpose. In a given 'release version' or not
  field :in_release, type: Boolean
  # merely for in development effort tracking purpose. Market (for bugs)
  field :market, type: String
  # merely for in development effort tracking purpose. Environment bug was found
  field :environment, type: String

  embedded_in :jira_issue, inverse_of: :work_logs
  embedded_in :tracking, inverse_of: :work_logs
end