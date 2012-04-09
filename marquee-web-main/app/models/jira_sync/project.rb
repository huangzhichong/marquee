class Project < ActiveRecord::Base

  establish_connection :jira_sub
  self.table_name = "project"
end
