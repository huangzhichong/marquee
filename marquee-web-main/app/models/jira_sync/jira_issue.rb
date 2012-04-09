class JiraIssue < ActiveRecord::Base

  establish_connection :jira_sub
  self.table_name = "jiraissue"
end
