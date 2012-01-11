class Jira::WorkLog
  include Mongoid::Document
  
  field :jira_id, type: String
  field :start_date, type: Date
  field :update_date, type: Date
  field :author, type: String
  field :time_worked, type: Integer

  embedded_in :issue, class_name: 'Jira::Issue', inverse_of: :work_logs
end