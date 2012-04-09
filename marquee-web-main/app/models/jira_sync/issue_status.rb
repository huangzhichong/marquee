class IssueStatus < ActiveRecord::Base

  establish_connection :jira_sub
  self.table_name = "issuestatus"
end
