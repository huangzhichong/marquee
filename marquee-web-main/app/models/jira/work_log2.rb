class Jira::WorkLog2
  include Mongoid::Document

  field :jira_id, type: String
  field :start_date, type: Date
  field :update_date, type: Date
  field :author, type: String
  field :time_worked, type: Integer
end