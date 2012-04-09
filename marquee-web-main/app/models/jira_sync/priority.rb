class Priority < ActiveRecord::Base

  establish_connection :jira_sub
  self.table_name = "priority"
end
