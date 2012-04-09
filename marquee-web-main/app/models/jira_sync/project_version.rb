class ProjectVersion < ActiveRecord::Base

  establish_connection :jira_sub
  self.table_name = "projectversion"
end
