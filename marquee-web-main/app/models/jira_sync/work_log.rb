class WorkLog < ActiveRecord::Base

  establish_connection :jira_sub
  self.table_name = "worklog"
end
